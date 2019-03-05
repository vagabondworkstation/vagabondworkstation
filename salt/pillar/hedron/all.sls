# Sooo hacky.
# Doing this partly because of unicode issues with module -> pillar, but initially because the cp module doesn't work inside of states with salt-ssh.
# FIXME: This seems to happen from the minon and not the master??
hedron.all_dirs:
{%- for dir in salt.cp.list_master_dirs() if not dir.startswith('hedron/.git') and dir != '.' and dir !='hedron' and dir != 'dist' %}
  - {{ dir }}
{%- endfor %}
