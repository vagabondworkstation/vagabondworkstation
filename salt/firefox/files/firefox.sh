#!/bin/sh

set -e

# If Firefox hasn't been ran yet, import our own custom config.
# I'm sure there's better ways to do this, but this seems like the best at the time.
if [ ! -d ~/.mozilla ]; then
    mkdir -p ~/.mozilla/firefox
    cp -r /usr/local/share/firefox_altered/* ~/.mozilla/firefox/
fi

/usr/bin/firefox
