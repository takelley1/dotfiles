#!/bin/bash

# Status bar script for printing the current system load, as seen in `top`.

# Emoji U+1F4CA 📈
# Font-Awesome f3fd  

load=$(awk '{print $1,$2,$3}' /proc/loadavg)

# Show Font-Awesome icons on Arch-based distros, use text everywhere else.
[[ -x "/usr/bin/pacman" ]] && printf "%s\n" " ${load}" || printf "%s\n" "LOAD ${load}"

exit 0
