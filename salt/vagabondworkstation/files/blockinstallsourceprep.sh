#!/bin/sh

set -e

# You probably don't want to run this.

rm /etc/ssh/*_host_*

rm -r /etc/tor/hidden_service_slot*

systemctl enable firstboot

sync
