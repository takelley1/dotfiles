#!/bin/bash

# Status bar script for printing the current system load, as seen in `top`.

# Emoji U+1F4CA 📈
# Font-Awesome f3fd  

# Show Font-Awesome icons on Arch-based distros, use text everywhere else.
if [[ -x "/usr/bin/pacman" ]]; then
    printf "%s\n" " $(cat /proc/loadavg | awk '{print $1,$2,$3}')"
else
    printf "%s\n" "LOAD $(cat /proc/loadavg | awk '{print $1,$2,$3}')"
fi

exit 0
