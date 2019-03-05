include:
  - hedron.desktop

vagabondworkstation_access_console_xephyr_service_file:
  file.managed:
    - name: /etc/systemd/system/access_console_xephyr.service
    - contents: |
        [Unit]
        Description=Access Console Xephyr
        After=startx.service
        [Service]
        ExecStart=/usr/bin/Xephyr :3 -screen 1280x720 -br
        Restart=always
        RestartSec=15
        Environment=DISPLAY=:0
        [Install]
        WantedBy=multi-user.target

vagabondworkstation_access_console_dwm_service_file:
  file.managed:
    - name: /etc/systemd/system/access_console_dwm.service
    - contents: |
        [Unit]
        Description=Access Console dwm
        After=access_console_xephyr.service
        [Service]
        ExecStart=/usr/bin/dwm
        ExecStartPost=/usr/bin/xsetroot -name "root on vagabondworkstation"
        Restart=always
        RestartSec=15
        Environment=DISPLAY=:3
        Environment=HOME=/root
        WorkingDirectory=/root
        [Install]
        WantedBy=multi-user.target

vagabondworkstation_access_console_slock_service_file:
  file.managed:
    - name: /etc/systemd/system/access_console_slock.service
    - contents: |
        [Unit]
        Description=Access Console slock
        After=access_console_dwm.service
        [Service]
        ExecStart=/usr/bin/slock
        Restart=on-failure
        RestartSec=1
        Environment=DISPLAY=:3
        [Install]
        WantedBy=multi-user.target

vagabondworkstation_access_console_slock_service_enabled:
  service.enabled:
    - name: access_console_slock

vagabondworkstation_access_console_xephyr_service_running:
  service.running:
    - name: access_console_xephyr
    - enable: True

vagabondworkstation_access_console_dwm_service_running:
  service.running:
    - name: access_console_dwm
    - enable: True
    - watch:
      - file: /etc/systemd/system/access_console_dwm.service
