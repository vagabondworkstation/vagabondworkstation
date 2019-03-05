base:
  'os:Debian':
    - match: grain
    - hedron.base
  'vagabondworkstation*':
    - vagabondworkstation
  '*_identity_vm':
    - identity_vm
  '*':
    - hedron.base.salted
