#!/usr/bin/env dash
#
# Status bar script that notifies the user if the daily pacman update job is
#   running so they don't reboot while it's happening.

if hash pacman 2>/dev/null; then
    if systemctl is-active aud.service --quiet; then
        printf "%s\n" "Updating system..."
    fi
fi

exit 0
