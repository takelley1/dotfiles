#!/bin/bash

# status bar script to print to the status bar if a file called "0pacman" is being run
# this is to notify the user if the hourly cron pacman update job is running so they don't reboot while it's happening

if [[ ! -z $(ps aux | grep '0pacman'| grep -v 'grep') ]]; then
    printf "performing automatic updates ... DO NOT REBOOT"
fi

exit 0
