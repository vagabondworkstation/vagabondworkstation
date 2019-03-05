# We speed this up slightly by separating VM creation (fast) and salting (slow).

include:
  - documentation
  - hedron.saltstack
  - .packages
  - .networking
  - hedron.qemu
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
