# Launches the decoy vm

decoy_vm_vm_launched:
  cmd.run:
    - name: ipxe-ubuntu-desktop bionic --vga | sporestackv2 launch --days 0 --api_endpoint http://127.0.0.1 --host 127.0.0.1 --ipxescript_stdin True --days 0 --bandwidth -1 --ipv4 nat --ipv6 nat --memory 2 --disk 25 --cores 1 --qemuopts "-display {{ pillar['vagabondworkstation.qemu.display'] }} -vga virtio -usb -soundhw hda -no-quit -name decoy_vm" decoy_vm
    - unless: sporestackv2 get_attribute decoy_vm expiration

decoy_vm_vm_lock_script_dependencies:
  pkg.installed:
    - name: xdotool

decoy_vm_vm_lock_script:
  file.managed:
    - name: /usr/local/sbin/decoy_lock
    - mode: 0500
    - source: salt://decoy_vm/files/decoy_lock.sh
    - user: root
    - group: user

decoy_vm_vm_lock_path:
  file.managed:
    - name: /var/tmp/decoy_lock
    - user: user
    - mode: 0600
    - contents: ''

decoy_vm_vm_lock_service:
  file.managed:
    - name: /etc/systemd/system/decoy_lock.service
    - contents: |
        [Unit]
        Description=decoy lock
        [Service]
        Type=oneshot
        ExecStart=/usr/local/sbin/decoy_lock
        Environment=DISPLAY=:0

decoy_vm_vm_lock_service_path:
  file.managed:
    - name: /etc/systemd/system/decoy_lock.path
    - contents: |
        [Unit]
        Description=Monitors for decoy_lock
        [Path]
        Unit=decoy_lock.service
        PathChanged=/var/tmp/decoy_lock
        [Install]
        WantedBy=multi-user.target

decoy_vm_vm_lock_service_path_running:
  service.running:
    - name: decoy_lock.path
    - enable: True
    - watch:
      - file: /etc/systemd/system/decoy_lock.path
