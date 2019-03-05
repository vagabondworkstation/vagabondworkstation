bvlock_dependencies:
  pkg.installed:
    - pkgs:
      - git
      - build-essential
      - libxrandr-dev

bvlock_source:
  file.recurse:
   - name: /usr/local/src/bvlock
   - source: salt://bvlock/files
   - include_empty: True
   - clean: True
   - file_mode: keep

bvlock_build_and_install:
  cmd.run:
    - name: make install
    - cwd: /usr/local/src/bvlock
    - creates: /usr/local/bin/bvlock

bvlock_helper:
  file.managed:
    - name: /usr/local/bin/bvlock_helper
    - mode: 0755
    - source: salt://bvlock/files/bvlock_helper.sh
