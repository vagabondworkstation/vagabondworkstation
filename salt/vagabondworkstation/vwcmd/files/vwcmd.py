#!/usr/bin/python3

# Helps administer a Vagabond Workstation.

import sys
import os
import json
import logging
from tempfile import TemporaryFile, mkdtemp
from tarfile import TarFile
from shutil import rmtree

import aaargh
from hedron import latest_only as hedron_latest_only
from paramiko import SSHClient, AutoAddPolicy
from sh import mount, umount, sync, keyplease

logging.basicConfig(level=logging.WARNING)

cli = aaargh.App()

os.umask(0o0077)


def list_virtual_machines():
    virtual_machines = []
    for entry in os.listdir('/etc/sporestackv2'):
        hostname = entry.split('.')[0]
        virtual_machines.append(hostname)
    return virtual_machines


def virtual_machine_info(hostname):
    json_file = os.path.join('/etc/sporestackv2', hostname + '.json')
    with open(json_file) as virtual_machine_json_file:
        virtual_machine_dict = json.load(virtual_machine_json_file)
    return virtual_machine_dict


@cli.cmd
def all_virtual_machines_info():
    vm_info_dict = {}
    for vm in list_virtual_machines():
        vm_info_dict[vm] = virtual_machine_info(vm)
    return vm_info_dict


@cli.cmd
def list_managed_virtual_machines():
    managed_virtual_machines = []
    all_virtual_machines = all_virtual_machines_info()
    for vm in all_virtual_machines:
        if vm.endswith('_identity_vm'):
            managed_virtual_machines.append(vm)
    return managed_virtual_machines


@cli.cmd
@cli.cmd_arg('hostname')
@cli.cmd_arg('command')
@cli.cmd_arg('port')
@cli.cmd_arg('--username', type=str, default='root')
@cli.cmd_arg('--key_filename', type=str, default='/etc/ssh/id_rsa')
def ssh(hostname,
        command,
        port=22,
        stdin=None,
        username='root',
        key_filename='/etc/ssh/id_rsa'):
    """
    FIXME: This may not fail out on non-zero exit statuses.
    """
    with SSHClient() as ssh_client:
        ssh_client.set_missing_host_key_policy(AutoAddPolicy())
        ssh_client.connect(hostname=hostname,
                           port=port,
                           username=username,
                           allow_agent=False,
                           look_for_keys=False,
                           key_filename=key_filename)
        ssh_stdin, stdout, stderr = ssh_client.exec_command(command)
        if stdin is not None:
            ssh_stdin.write(stdin)
            ssh_stdin.flush()
            ssh_stdin.channel.shutdown_write()
        return stdout.read()


@cli.cmd
@cli.cmd_arg('command')
@cli.cmd_arg('--username', type=str, default='root')
def ssh_all(command, username='root', allow_failures=False):
    """
    ssh() for all VMs on the host.

    allow_failures will keep going even if an ssh() fails.
    This is useful if say we want to lock VMs and one isn't running.
    Odds are, we will die before we can lock all the VMs.
    """
    all_output = b''
    failures = []
    for host in list_managed_virtual_machines():
        host_dict = virtual_machine_info(host)
        key_filename = keyplease.private(host_dict['vm_hostname']).strip('\n')
        output = b''
        try:
            output = ssh('127.0.0.1',
                         command,
                         host_dict['slot'],
                         username=username,
                         key_filename=key_filename)
        except TypeError as e:
            raise(e)
        except Exception as e:
            if allow_failures is True:
                logging.warning('Connection to {} failed.'.format(host))
                logging.debug('Exception: {}'.format(e))
                failures.append(e)
            else:
                raise(e)
        all_output = all_output + output

    if allow_failures is True:
        return all_output, failures
    else:
        return all_output


def _prune_tar(members):
    for member in members:
        if member.isreg():
            yield member


@cli.cmd
def brainvault_backup(latest_only=True):
    command = 'tar -C /var/tmp/brainvault-persistence -cf - .'
    tempdir = mkdtemp()
    for host in list_managed_virtual_machines():
        host_dict = virtual_machine_info(host)
        key_filename = keyplease.private(host_dict['vm_hostname']).strip('\n')
        with TemporaryFile() as temporaryfile:
            temporaryfile.write(ssh('127.0.0.1',
                                    command,
                                    host_dict['slot'],
                                    key_filename=key_filename))
            temporaryfile.seek(0, 0)
            tar = TarFile(fileobj=temporaryfile)
            tar.extractall(path=tempdir, members=_prune_tar(tar))
            tar.close()
    backup_worthy_files = []
    for file in os.listdir(tempdir):
        if file.endswith('X.tar.xz.ccrypt'):
            backup_worthy_files.append(file)
    if latest_only is True:
        backup_worthy_files = hedron_latest_only(backup_worthy_files)
    tarfile = TemporaryFile()
    tar = TarFile(fileobj=tarfile, mode='w')
    for file in backup_worthy_files:
        full_path = os.path.join(tempdir, file)
        tar.add(full_path, arcname=file)
    rmtree(tempdir)
    tar.close()
    tarfile.seek(0, 0)
    tar_output = tarfile.read()
    tarfile.close()
    return tar_output


# FIXME: Update to newer stdin= system..
@cli.cmd
def brainvault_restore(stdin=True, input=None):
    command = 'tar -C /var/tmp/brainvault-persistence -xf -'
    with TemporaryFile() as temporaryfile:
        if stdin is True:
            temporaryfile.write(sys.stdin.buffer.read())
        else:
            temporaryfile.write(input)
        for host in list_managed_virtual_machines():
            host_dict = virtual_machine_info(host)
            # Yuck.
            key_filename = keyplease.private(host_dict['vm_hostname'])
            key_filename = key_filename.strip('\n')
            temporaryfile.seek(0, 0)
            ssh('127.0.0.1',
                command,
                host_dict['slot'],
                stdin=temporaryfile.read(),
                key_filename=key_filename)
    return True


@cli.cmd
def brainvault_prune():
    """
    Prune brainvault backups to just the latest on all local VMs.
    """
    ssh_all('brainvault_persistence_py prune_backups')
    return True


@cli.cmd
def brainvault_lock_all_vms():
    """
    Lock all VMs. Doesn't double lock if already locked.
    """
    # Redirect stuff is so ssh can return when we background.
    _, failures = ssh_all('bvlock_helper > /dev/null 2> /dev/null < /dev/null',
                          username='user',
                          allow_failures=True)
    if len(failures) == 0:
        return True
    else:
        return False


@cli.cmd
def brainvault_unlock_all_vms():
    """
    Unlock all locked VMs.
    """
    _, failures = ssh_all('killall bvlock',
                          username='user',
                          allow_failures=True)
    if len(failures) == 0:
        return True
    else:
        return False


@cli.cmd
@cli.cmd_arg('device')
@cli.cmd_arg('file')
def mount_write(device, file, stdin=True, input=None):
    """
    Mount a device and write a file, then unmount.
    """
    mount_point = mkdtemp()
    mount(device, mount_point)
    with open(os.path.join(mount_point, file), 'wb') as output_file:
        if stdin is True:
            output_file.write(sys.stdin.buffer.read())
        else:
            output_file.write(input)
    umount(mount_point)
    sync()
    os.rmdir(mount_point)
    return True


@cli.cmd
@cli.cmd_arg('device')
@cli.cmd_arg('file')
def mount_read(device, file):
    """
    Mount a device and read a file, then unmount.
    """
    mount_point = mkdtemp()
    mount(device, mount_point)
    with open(os.path.join(mount_point, file), 'rb') as input_file:
        output = input_file.read()
    umount(mount_point)
    sync()
    os.rmdir(mount_point)
    return output


if __name__ == '__main__':
    output = cli.run()
    if output is True:
        sys.exit(0)
    elif output is False:
        sys.exit(1)
    elif output is None:
        sys.exit(0)
    else:
        if isinstance(output, bytes):
            sys.stdout.buffer.write(output)
        else:
            sys.stdout.write(output)
