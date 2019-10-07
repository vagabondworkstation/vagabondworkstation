# Lock root password for identity VM, not for host.
{% if grains['id'].endswith('identity_vm') %}
hedron.users.root_password: '!'
{% endif %}
