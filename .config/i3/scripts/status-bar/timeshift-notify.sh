#!/bin/bash

# status bar script to print to the status bar if timeshift is running
# this is to notify the user if the daily timeshift snapshot job is running so they don't reboot while it's happening

if [[ ! -z $(ps aux | grep 'timeshift' | grep -v 'grep' | grep -iE 'rsync|btrfs') ]]; then
    printf "%s\n" "managing snapshots ..."
fi

exit 0
