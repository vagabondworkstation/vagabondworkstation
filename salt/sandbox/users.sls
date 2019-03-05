# "Sandbox" users

# We use this because we are on an old systemd. Ideally would use BindPaths.
# So much easier...
# If we wanted to upgrade Systemd we'd have to consider rebooting the system to
# then get the latest version's features. At least, it seems?
sandbox_users_sandbox_directory:
  file.directory:
    - name: /sandbox
    - user: user
    - group: user
    - mode: 0750

## Browser user
sandbox_users_make_user_group_browser:
  group.present:
    - name: browser
    - gid: 1975

sandbox_users_make_user_browser:
  user.present:
    - name: browser
    - uid: 1975
    - gid: 1975
    - home: /sandbox/browser/browser
    - createhome: False
    - shell: /bin/false
    - groups:
      - audio

# We use this so another sandbox user can't probe around in the other sandbox user's stuff.
sandbox_users_make_user_browser_home_base:
  file.directory:
    - name: /sandbox/browser
    - user: browser
    - group: user
    - mode: 0700

# This is the real deal, but it gets bind mounted so permissions should be handled there.
sandbox_users_make_user_browser_home_real:
  file.directory:
    - name: /sandbox/browser/browser

## Bitmessage user
sandbox_users_make_user_group_bitmessage:
  group.present:
    - name: bitmessage
    - gid: 1976

sandbox_users_make_user_bitmessage:
  user.present:
    - name: bitmessage
    - uid: 1976
    - gid: 1976
    - home: /sandbox/bitmessage/bitmessage
    - createhome: False
    - shell: /bin/false

# We use this so another sandbox user can't probe around in the other sandbox user's stuff.
sandbox_users_make_user_bitmessage_home_base:
  file.directory:
    - name: /sandbox/bitmessage
    - user: bitmessage
    - group: user
    - mode: 0700

# This is the real deal, but it gets bind mounted so permissions should be handled there.
sandbox_users_make_user_bitmessage_home_real:
  file.directory:
    - name: /sandbox/bitmessage/bitmessage
