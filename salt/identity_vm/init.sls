include:
  - documentation
  - extra_users
  - hedron.audio
  - hedron.raru
  - hedron.brainvault
  - hedron.wormhole
  - hedron.irc_otr
  - hedron.xterm
  - hedron.desktop
  - hedron.desktop.xinitrc
  - hedron.xorg
  - hedron.golang
  - bvlock
  - sandbox
  - hedron.sporestack
  - hedron.sporestack.helper
  - hedron.develop_this

# develop_this is probably excessive for most.

# Not sure how to best break these up.
identity_vm_packages:
  pkg.installed:
    - pkgs:
      - sxiv
      - scrot
      - xdotool
      - fetchmail
      - mutt
      - procmail
      - msmtp
      - suckless-tools

# user is where you'd run brainvault
# Others might be clearnet proxy firefox, firefox, bitmessage, then untrusted.
{% for user in ['user', 'user1972', 'user1973', 'user1974'] %}
identity_vm_xterm_{{ user }}_running:
  service.running:
    - name: xterm@{{ user }}
    - enable: True
{% endfor %}
