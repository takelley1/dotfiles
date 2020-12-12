#!/usr/bin/env dash
#
# Status bar script to print a notification if Timeshift is running.
# This is to notify the user if the daily timeshift snapshot job is
#   running so they don't reboot while it's happening.

if [ -n "$(pgrep -u 'root' 'timeshift')" ]; then
    printf "%s\n" "Managing snapshots..."
fi

exit 0
