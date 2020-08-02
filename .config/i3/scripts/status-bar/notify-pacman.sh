#!/usr/bin/env dash
#
# Notify the user if the daily pacman update job is running so they
#   don't reboot while it's happening.

if [ -x "/usr/bin/pacman" ] && [ -n "$(pgrep --newest --euid root -f "pacman -Syyu")" ]; then
  printf "%s\n" "Running pacman..."
fi

exit 0
