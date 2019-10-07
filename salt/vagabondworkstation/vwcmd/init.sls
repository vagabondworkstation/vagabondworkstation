# vwcmd: for administering vagabondworkstation.

# This is broken on Debian Buster: https://github.com/paramiko/paramiko/issues/1517
# Not sure of any fix at the moment.

include:
  - hedron.pip.python3

vagabondworkstation_vwcmd_dependencies:
  pip.installed:
    - pkgs:
      - aaargh
      - sh
      - paramiko
    - bin_env: /usr/bin/pip3

vagabondworkstation_vwcmd_install:
  file.managed:
    - name: /usr/local/sbin/vwcmd
    - mode: 0500
    - source: salt://vagabondworkstation/vwcmd/files/vwcmd.py
