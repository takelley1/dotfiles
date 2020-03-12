#!/bin/bash

# Status bar script to print a notification if Timeshift is running.
# This is to notify the user if the daily timeshift snapshot job is running so they don't reboot while it's happening.

if [[ -n $(ps aux | grep 'timeshift' | grep -v 'grep' | grep -iE 'rsync|btrfs') ]]; then
    printf "%s\n" "managing snapshots ... DO NOT REBOOT"
fi

exit 0
