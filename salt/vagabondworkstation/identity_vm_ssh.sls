vagabondworkstation_identity_vm_ssh_installed:
  file.managed:
    - name: /usr/local/sbin/identity_vm_ssh
    - mode: 0755
    - source: salt://vagabondworkstation/files/identity_vm_ssh.sh
