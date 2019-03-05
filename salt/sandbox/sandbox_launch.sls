sandbox_launch_script:
  file.managed:
    - name: /usr/local/bin/sandbox_launch
    - source: salt://sandbox/files/sandbox_launch.sh
    - mode: 0555
