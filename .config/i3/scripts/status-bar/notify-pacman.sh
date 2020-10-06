#!/usr/bin/env dash
#
# Notify the user if the daily pacman update job is running so they
#   don't reboot while it's happening.

if [ -x "/usr/bin/pacman" ]; then
    if pgrep --newest --full --list-full "aud.sh" | grep -qEv "EDITOR|vi"; then
        printf "%s\n" "Updating system..."
    else
        exit 0
    fi
else
    exit 0
fi
exit 0
