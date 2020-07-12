#!/bin/dash

# Notify the user if the daily anacron pacman update job is running so they don't reboot while it's happening.

[ -x "/usr/bin/pacman" ] && [ -n "$(pgrep --newest --euid root pacman)" ] && printf "%s\n" "Running pacman - DO NOT REBOOT"

exit 0
