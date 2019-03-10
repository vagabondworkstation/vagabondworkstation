#!/bin/sh

set -e

export DISPLAY=:0

systemctl start access_console_slock

# Suspicious output should be logged to console.
# We'll also give a non-zero exit status but continue processing.
if ! vwcmd brainvault_lock_all_vms; then
    EXIT_STATUS=1
else
    EXIT_STATUS=0
fi

# We now have a hack to set this as we'd want it, anyway.
decoy_vm_machine_id='decoy_vm'

# For some reason openbox can't be found with xdotool search --name Openbox, but this works...
for window in $(xdotool search '.*' 2> /dev/null); do
    if xdotool getwindowname "$window" | grep -qF Openbox; then
        openbox_window=$window
        break
    fi
done

# Remove focus from current window, switch to the desktop with decoy VM.
xdotool sleep 0.2 windowfocus "$openbox_window" sleep 0.2 set_desktop "$(xdotool search --name "$decoy_vm_machine_id" get_desktop_for_window)"
# Full screen decoy
xdotool sleep 2 windowfocus "$(xdotool search --name "$decoy_vm_machine_id")" sleep 3 key ctrl+alt+f
# FIXME: This is the same keycombo we use for locking, so could loop...
# Doesn't actually loop? I guess qemu captures the keys. But there are cases where user might not want to lock the decoy anyway.
# Lock decoy, should have no effect if already locked.
#xdotool sleep 3 key ctrl+alt+l

exit "$EXIT_STATUS"
