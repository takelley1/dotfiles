#!/bin/bash

# status bar script to print to the status bar if a file called "0pacman" is being run
# this is to notify the user if the hourly cron pacman update job is running so they don't reboot while it's happening

# check if the system uses pacman
if [[ -x "/usr/bin/pacman" ]]; then
    # check if the pacman updater is running
    if [[ ! -z $(ps aux | grep '0pacman'| grep -v 'grep') ]]; then
        printf "%s\n" "performing automatic updates ... DO NOT REBOOT"
    fi
fi

exit 0
