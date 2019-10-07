# Debian Stretch supports -display sdl, Debian Buster supports -display gtk, but only with qemu-system-gui installed. No overlap.
{% if grains['oscodename'] == 'stretch' %}
vagabondworkstation.qemu.display: sdl
{% else %}
vagabondworkstation.qemu.display: gtk
{% endif %}
