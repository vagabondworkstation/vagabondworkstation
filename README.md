Clone hedron into salt/hedron, then you can modify, test with `salt/hedron/salt_utilities/files/test.sh`, etc.

Pull changes into your workstation (/srv/salt) and run `salt-call --local -l info state.highstate` to highstate.

Documentation: salt/documentation/files/vagabondworkstation.md
