# Points firefox to our prefs.js profile.
firefox_altered_profile_ini:
  file.managed:
    - name: /usr/local/share/firefox_altered/profiles.ini
    - source: salt://firefox/files/profiles.ini
    - makedirs: True

# We set things here like allowing .onion, adding "tracking protection", disabling search suggestions,
# privacy tweaks, etc.
firefox_altered_prefs_js:
  file.managed:
    - name: /usr/local/share/firefox_altered/default/prefs.js
    - source: salt://firefox/files/prefs.js
    - makedirs: True

# Search engine default is more complicated. The file has some weird encryption based on the directory name of the profile.
# prefs.js can't set this. It seems built into the binary, so not easy to fix elsewhere.
# This is done manually, just has DuckDuckGo as a default. Google doesn't work well over Tor anyway.
# If we change the profile folder from "default", we have to update this as well.
firefox_altered_search_json:
  file.managed:
    - name: /usr/local/share/firefox_altered/default/search.json.mozlz4
    - source: salt://firefox/files/search.json.mozlz4
    - makedirs: True

firefox_altered_installed:
  file.managed:
    - name: /usr/local/bin/firefox
    - source: salt://firefox/files/firefox.sh
    - mode: 0555
