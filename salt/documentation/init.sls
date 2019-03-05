vagabond_documentation:
  file.managed:
    - name: /usr/local/share/doc/vagabond.md
    - source: salt://documentation/files/vagabond.md
    - makedirs: True
