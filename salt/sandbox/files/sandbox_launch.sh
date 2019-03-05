#!/bin/sh

set -e

usage() {
    [ -n "$1" ] && echo "Error: $1" >&2
    echo "Usage: $0 <browser|bitmessage> (Must be ran as the \"user\" user.)" >&2
    exit 1
}

[ "$(whoami)" != 'user' ] && usage 'You are not "user".'

APP=$1

case "$APP" in
    browser)
        ;;
    bitmessage)
        ;;
    "")
        usage
        ;;
    *)
        usage 'Invalid app.'
        ;;
esac

# Just a `touch` won't do.
date +%s > ~/.sandbox_launch/"$APP"
