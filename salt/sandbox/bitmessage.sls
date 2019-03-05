include:
  - hedron.bitmessage.pybitmessage
  - hedron.notbit.bitmessage_address_generator
  - hedron.tor

# hedron.tor for tor.client, which gives us a local tor client connection for bitmessage.

sandbox_bitmessage_mount_service_file:
  file.managed:
    - name: /etc/systemd/system/sandbox-bitmessage-bitmessage.mount
    - source: salt://sandbox/files/sandbox-bitmessage-bitmessage.mount

sandbox_bitmessage_main_service_file:
  file.managed:
    - name: /etc/systemd/system/sandbox_bitmessage.service
    - source: salt://sandbox/files/sandbox_bitmessage.service

sandbox_bitmessage_path_service_file:
  file.managed:
    - name: /etc/systemd/system/sandbox_bitmessage.path
    - contents: |
        [Unit]
        Description=Launches sandbox bitmessage
        [Path]
        PathChanged=/home/user/.sandbox_launch/bitmessage
        [Install]
        WantedBy=multi-user.target

sandbox_bitmessage_path_service_running:
  service.running:
    - name: sandbox_bitmessage.path
    - enable: True
