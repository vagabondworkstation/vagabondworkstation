base:
  'os:Debian':
    - match: grain
    - hedron.base
  'vagabondworkstation*':
    - vagabondworkstation
  'debian':
    - identity_vm
  '*_identity_vm':
    - identity_vm
  '*':
    - hedron.base.salted
