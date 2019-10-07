# We speed this up slightly by separating VM creation (fast) and salting (slow).

# We disable swap as VMs may have sensitive data. Rootfs may or may not be encrypted. If it is, gives us an extra measure of security.

# We could use vmmanagement.baremetal_tor and then --operating_system / --ssh_key_file, but... the install logs would all show the same .onion unique to the host and correlate them.
# Ideally would be able to run a pastebin with a different .onion per paste?
# For now, sticking with ipxe-buster

include:
  - hedron.base.disable_swap
  - documentation
  - hedron.saltstack
  - .packages
  - .networking
  - hedron.qemu
  - .qemu_buster
  - hedron.vmmanagement.baremetal
  - hedron.audio
  - hedron.tornet
  - hedron.openbox
  - .xinitrc
  - hedron.xorg
  - .vwcmd
  - .access_console
  - identity_vm.red_vm.vm
  - decoy_vm.vm
  - wicd
  - hedron.golang
  - .identity_vm_ssh
  - identity_vm.red_vm.salted
