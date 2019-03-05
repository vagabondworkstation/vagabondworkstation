# Launches the yellow identity vm, itself.

# Unfortunately, don't yet have a good way to templatize this in a salt-callable way.

identity_vm_yellow_vm_vm:
  cmd.run:
    - name: keyplease generate yellow_identity_vm; ipxe-stretch $(keyplease public yellow_identity_vm) --vga | sporestackv2 launch --days 0 --api_endpoint http://127.0.0.1 --host 127.0.0.1 --ipxescript_stdin True --bandwidth -1 --ipv4 tor --ipv6 tor --memory 2 --disk 20 --cores 1 --qemuopts "-display sdl -vga virtio -usb -soundhw hda -no-quit -name yellow_identity_vm" --managed True yellow_identity_vm
    - unless: sporestackv2 get_attribute yellow_identity_vm expiration
