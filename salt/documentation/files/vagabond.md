# Vagabond Workstation Documentation

The Vagabond Workstation has been engineered to be a secure workstation
with the concept of the user coming before the organization. You, the user,
own your hardware. This is merely a tool to help protect your anonimity and
enable freer trade. Traffic is sent through Tor by default.  Your ISP and
your coffee shop owner will know that you use Tor but little else.

One of the primary premises is that as much as possible should be stored
in one memorized phrase. Ideally so that you can switch hardware and get up
and running without even a USB stick or remote file store with your digital
belongings.

Like all "secure" workstations they are ultimately limited by you, the user.
You still still have to practice safe habits considering timing, information
shared, security, etc.

## High level overview

Vagabond Workstation uses Debian Stretch. It is a VM host using Qemu/KVM. It
can host a number of VMs (Virtual Machines), but runs two by default. These
are red_identity_vm and decoy_vm. None of these can "talk" to the host. The
host can "talk" to them via SSH. Networking is Qemu user mode.

The baremetal OS and each VM has its own Tor process to isolate all network
traffic. It's also important to isolate the VM from the baremetal as much as
possible. Even running a browser on the baremetal will almost immediately
expose your identity through Javascript battery APIs, MAC addresses, CPU
identifiers, local network addresses, etc.

Thus, if you have two identities which you want to use then you can isolate
them by running each identity on a different VM. Do not attempt to use two
identities on a single identity_vm.

Disk security is a combination of encrypted rootfs and keeping the most
sensitive documents from every touching the disk through tmpfs. Further, swap
is not used anywhere by default. Encrypted rootfs is not strictly necessary but
can also help make tampering more difficult if your device is able to be taken
without your knowledge. It also acts as a second layer of encryption if used.

VMs are accessed with different SSH keys and so shouldn't have any data in
common between them that would link your VMs together vs any other Vagabond
Workstation VMs.

## System requirements

Vagabond Workstation has varying memory requirements depending on the number
of VMs that you want to run. The bare minimum is 6GiB to install at this time.

16GiB is better if you want to run multiple identities. 8GiB will let you
run three VMs (counting the decoy). Each VM needs 2GiB of memory. We only
allocate 1 core per VM for potential security reasons.

The decoy_vm is Ubuntu 18.04 and has traffic not Torified. You can do your
"personal" use on it if you like, browse Youtube, bypass captive portals
(wifi hotspot logins), etc. The default password for the decoy_vm is "debian".

## Installation

`dd` the ISO to a USB stick. Boot the USB stick.

Installer is fairly automated but there are some steps. You will have to go
through on your own.

Select your network hardware (ethernet generally only works) and configure
your partitioning. Generally, only the guided modes seem to work, rootfs
and without. Manual mode is broken, unfortunately.

After install is finished, reboot and be patient. If you have failed installs
in the VMs, you may want to ctrl+alt+f9 to restart or debug, or give it all
another go.

When you see a 'Xephyr :3' window in X, give it focus and press ctrl
alt+shift+enter to launch a terminal. Set root's password with `passwd`,
else you will be eternally locked out. The window manager inside the Xephyr
is dwm, which is also used in any identity_vm.

## Basic usage

Your Unix username is "user". There are no logins, no real accounts. You
are stripped of name and identity except what you give back to yourself.

"user" is completely ephemeral by default. /home/user is your home directory
and it is mounted in tmpfs. Keep in mind as well that what you login to
is not the OS on the baremetal, but a VM on the baremetal. There are also
user1972-user1974 accounts with the same behavior. Their purpose is to help
sandbox applications, not identities.

brainvault manages your core identity including wallets, SSH key, communication
(through Bitmessage), email (which you have to setup manually, but we provide
deterministic email addresses and passwords for you), and data persistence
features. The data persistence can be synced to local USB drives and/or to
MEGA.nz, after an account has been made. Given the limitations of the system,
lack of rewrites, it would be foolish to rely on the system for say more
than 100MiB of data. If you need more storage than that, modularize it and
find other solutions.

### Creating a brainvault

Pick a passphrase/mnemoic. You cannot change it and you cannot recover it
inside of this system.

Now run: `brainvault YourPassphrase`

It will tell you to source your bashrc. Do that with `. ~/.bashrc`.

Now you're in. You *can* store files on the local machine and recover them
later. Do this with `brainvault-persistence backup`. They will be extracted
automatically if present, when you run `brainvault` next time. Most dotfiles
are not saved by default, you will have to add these with a ~/.brainvaultrc
file if you want to keep them.

Keep in mind that protecting this user, key, and the files in your home
directory are important at all costs.

To backup to MEGA: `brainvault-persistence backup --mega`

If you want to restore a brainvault and its data from MEGA, instead run:
`brainvault YourKeyX --fetch_from mega`

Note that this won't work unless you've manually registered an account on
MEGA, using the steps provided by `brainvault-banner`.

### Web browsers

As user, `sandbox_launch browser`

The browser is effectively quite a bit like Tor Browser, although probably
not quite as well tuned for such use. Keep that in mind. Since you are using
it on a VM it's not so much of an issue. This cannot be stressed enough, do
not attempt to run a torified browser on the baremetal! It is fundamentally
a sieve when it comes to your identity.

This will exit out of Tor. If you wish to avoid the captchas and have a
cleaner exit, consider spinning up a clearnet socks exit. Not discussed here,
but working implementations are provided in the "hedron" salt repository.

### Bitmessage

As user, `sandbox_launch bitmessage`

### Email and MEGA

Now that you can browse, consider creating an email account and MEGA for
storing your braunvault-persistence data "in the cloud". The email address
is primarily for validating services, however you can also communicate with
it. Bitmessage is preferable for a number of reasons, but of course has
numerous limitations over email (and some unique benefits).

You can run `brainvault-banner` as user to see your suggested username and
email (`brainvault YourPassphrase` also shows this but should only be ran
once per VM boot). You should sign up your email first.

Once you have your email account, register with MEGA. However, do not do it
with the browser. Follow the instructions in `brainvault-banner` to register.

### Brainvault features

 * Persistence on the host, if you choose to use it.

 * Persistence on MEGA.

 * An SSH key, based on the brainkey.

 * Bitcoin, Bitcoin Cash wallet with `walkingliberty`.

 * Clearnet servers on SporeStack, paid for out of your `walkingliberty`
 wallet.

 * Hidden servers on SporeStack, paid for out of your `walkingliberty` wallet.

 * Bitmessage, based on your key.

 * Email and MEGA.nz, based on deterministic usernames and passwords.

Want a new identity? Just create another brainvault and use it on a
different VM.

### Basic sandboxing techniques

If you normally use "user", run something in "user1972" or similar. That
gives you filesystem and `ps` protection between the two.

If you want something very ephemeral, you can run it with `raru` as a
prefix. This has limitations.

There is also `johndoe` which may be helpful in some situations.

Keep in mind that there are no X protections, and thus your Firefox browser
could easily become compromised and X keylog your passwords or X screen capture
your terminal while you use it. More work needs to be done on that front.

### Administrator access

Unlock the window 'Xephyr on :3' with your root password. At first boot,
it should be unlocked for you. After that, it will be locked and look blank
(suckless' slock).

### Using salt.

A highstate brings the system to its base minimum configuration. If you have
a local salt repository in /srv/salt, you can use `salt-call`. If you are
connecting to another machine you can use `salt-ssh`.

Local salt usage always starts with: `salt-call --local -l info`

You can drop the `-l info`, but it comes in handy often.

 * Highstate: `root@vagbondworkstation# salt-call --local -l info

 * Another identity VM: `root@vagbondworkstation# salt-call --local -l info
 state.sls identity_vm.orange_vm`

### IRC:

Identity VMs on your Vagabond Workstation are equipped with irssi and the
OTR plugin. Consider running with `dtach` so you can connect to it from
somewhere else.

Example: `mkdir ~/.dtach; dtach -A ~/.dtach/irssi irssi`

#### Enabling OTR:

 * `/load otr`

 * `/statusbar window add otr`

 * Then in a chat: `/otr init` -- Initial key generation on both ends may
 take minutes -- run this a few times if you have to.

### Connecting to wifi

As root@vagabondworkstation, run `wicd-gtk`. This seems to maybe get reset
every day or two and may need to be reconnected manually. You can always stop
the wicd service (`systemctl stop wicd`) and manually use wpa_supplicant if
on a WPA network.

### Locking your workstation

It's recommended that you login to your decoy_vm and set the resolution to
your native resolution. Once that is done, you can click away from any Qemu
window and press ctrl+alt+l to lock all of your identity_vms. They will be
locked with the brainvault passphrase, which will have to be typed into the
blank screen to unlock. Further, ctrl+alt+l should switch desktop workspaces
to the decoy_vm and attempt to full screen it. This process is not completely
reliable, however the locking can be quite reliable.

If the automatic switch to decoy_vm does not work, you can switch desktops
(mouse wheel or ctrl+alt+left/right) and ctrl+alt+f on the decoy_vm. There
may be some graphical glitches with the window appearing black, but move
your cursor a bit and in a moment those should clear up. Thus, if someone
else opens your laptop they will just see a mundane Ubuntu install.

To unlock, get out of full screen by pressing ctrl+alt+f, and cycle
over to the respective VM windows and unlock them with your brainvault
phrase.  To speed this up, you can also unlock Xephyr :3 and run `vwcmd
brainvault_unlock_all_vms` on vagabondworkstation, to unlock the rest of
your VMs (other than decoy_vm).

If you are using a laptop and wish to suspend it in this state, you can run
a `sleep 20; systemctl suspend`, then lock as normal. After 20 seconds it
should have suspended as usual.

Changing the user on Ubuntu and making it look less "fishy" is not a bad idea,
along with changing the password from "debian".

### Developing the codebase

First get the code. Should consist of two repositories stacked, like
vagabondworkstation/ and vagabondworkstation/salt/hedron.


 * Run first tests to make sure it's working:
 `salt/hedron/salt_utilities/files/test.sh`

(Once it gets to salt show_top/show_sls type of stuff, you can usually safely
kill it. Only a few bugs are caught after that point.

### Remastering the ISO

First delete the ISOs you want to have remastered, if already present.

 * `root@vagabondowrkstation# rm /var/tmp/hedron.iso`

 * `root@vagabondworkstation# salt-call --local -l debug state.sls
 hedron.remaster`

Now you can find it as /var/tmp/hedron.iso. `dd` or `pv` to your heart's
content.

### Connecting into vagabondworkstation, red_identity_vm, then irssi from
your LAN.

 * `anotheruser@otherworkstation$ ssh root@LANIP` (You will need to manually
 add a key onto vagabondworkstation's /etc/ssh/authorized_keys.extra and
 /etc/ssh/authorized_keys)

 * `root@vagabondworkstation# identity_vm_ssh red_identity_vm`

 * `user@red_idenity_vm$ dtach -a ~/.dtach/irssi`

### Tips and tricks

 * Adjust your screen redness (to make it easier on your eyes at night) with
 `vagabondworkstation #DISPLAY=:0 sct 2000`. Adjust the number accordingly,
 lower is redder, higher is bluer. Run it without any number to reset it
 back to normal.

 * If you boot up and find the content in your Qemu windows to look a bit
 small and distorted, you can give them focus and ctrl+alt+u to reset the
 window's resolution to that of the VM.

 * If you have Tor networking issues in a VM where one particular site
 just won't load or is very slow, you can use carml's newid feature or try
 restarting the tornet@1(slot number of VM) service on vagabondworkstation. If
 you are connecting to a hidden service, you'll need to wait up to 60 seconds
 in the identity VM, or restart systemd-resolved on said identity VM.

### Caveats

This *may* work safely for kiosk use, but ideally keep it to
yourself. Practically speaking, physical possession of your hardware makes
it impossible to trust.

You can su to the openvpn user on vagabondworkstation if you want to talk
through non-tor.
