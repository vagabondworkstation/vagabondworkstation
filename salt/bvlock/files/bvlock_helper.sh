#!/bin/sh

set -e

export DISPLAY=:0

[ -f ~/.bvlock ] || touch ~/.bvlock

(flock -n ~/.bvlock bvlock || exit 0) &
