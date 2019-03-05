include:
  - firefox

sandbox_browser_mount_service_file:
  file.managed:
    - name: /etc/systemd/system/sandbox-browser-browser.mount
    - source: salt://sandbox/files/sandbox-browser-browser.mount

sandbox_browser_main_service_file:
  file.managed:
    - name: /etc/systemd/system/sandbox_browser.service
    - source: salt://sandbox/files/sandbox_browser.service

sandbox_browser_path_service_file:
  file.managed:
    - name: /etc/systemd/system/sandbox_browser.path
    - contents: |
        [Unit]
        Description=Launches sandbox browser
        [Path]
        PathChanged=/home/user/.sandbox_launch/browser
        [Install]
        WantedBy=multi-user.target

sandbox_browser_path_service_running:
  service.running:
    - name: sandbox_browser.path
    - enable: True
