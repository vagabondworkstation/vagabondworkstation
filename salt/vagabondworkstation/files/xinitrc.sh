#!/bin/sh

set -e

# Be aware that setting non-default resolutions can sometimes make qemu full screen mode horribly buggy.

xrandr | head -n 1 | awk '{print $8 "x" $10}' | tr -d , > /etc/X11/default_resolution
# Pick a "common" resolution for VMs, instead.
echo 1280x720 > /etc/X11/default_resolution

##
# Believe it or not, this works.
#sleep infinity
#
# If nothing is running X just goes away so we need something.
##

su - user -c 'openbox --sm-disable'
