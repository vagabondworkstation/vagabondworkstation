vagabondworkstation_xinitrc:
  file.managed:
    - name: /etc/X11/xinit/xinitrc
    - mode: 0700
    - source: salt://vagabondworkstation/files/xinitrc.sh
