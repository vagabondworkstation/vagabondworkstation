# Debian Buster's qemu doesn't include display support for sdl or gtk. This package gives it to us for gtk.

{% if grains['oscodename'] == 'buster' %}
vagabondworkstation_qemu_buster_gtk:
  pkg.installed:
    - name: qemu-system-gui
{% endif %}
