# More pseudonym accounts. `johndoe` doesn't play well with ssh so partly the reason for this.

{% for user in ['1972', '1973', '1974'] %}
extra_users_make_user_group_{{ user }}:
  group.present:
    - name: user{{ user }}
    - gid: {{ user }}

extra_users_make_user_{{ user }}:
  user.present:
    - name: user{{ user }}
    - uid: {{ user }}
    - gid: {{ user }}
    - home: /home/user{{ user }}
    - createhome: False
    - shell: /bin/bash
    - groups:
      - audio

extra_users_user_home_directory_{{ user }}:
  file.directory:
    - name: /home/user{{ user }}
    - user: user{{ user }}
    - group: user{{ user }}
    - mode: 700

extra_users_user_home_tmpfs_{{ user }}:
  mount.mounted:
    - name: /home/user{{ user }}
    - device: tmpfs
    - fstype: tmpfs
    - opts: defaults,mode=700,uid={{ user }},gid={{ user }}
{% endfor %}
