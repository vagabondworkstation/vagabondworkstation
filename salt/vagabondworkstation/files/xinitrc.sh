#!/bin/sh

set -e

# Be aware that setting non-default resolutions can sometimes make qemu full screen mode horribly buggy under some video drivers.

#xrandr | head -n 1 | awk '{print $8 "x" $10}' | tr -d , > /etc/X11/default_resolution
# Pick a "common" resolution for VMs, instead.
echo 1280x720 > /etc/X11/default_resolution

##
# Believe it or not, this works.
#sleep infinity
#
# If nothing is running X just goes away so we need something.
##

# This is a hack for now, for Debian Buster
# Sometimes we get .Xauthority, sometimes we don't?
chmod 644 /.Xauthority || true

# Consdier switching this to raru?
su - user -c "DISPLAY=$DISPLAY openbox --sm-disable"
