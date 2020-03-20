#!/bin/bash

# Status bar script for printing the current swap space usage in megabytes.

# Emoji U+1F504 🔄
# Font-Awesome f56f 

swap_used=$(echo $(cat /proc/swaps | awk '{print $4}' | tail -1) / 1000 | bc)

# Show Font-Awesome icons on Arch-based distros, use text everywhere else.
[[ -x "/usr/bin/pacman" ]] && printf "%s\n" " ${swap_used}M" || printf "%s\n" "SWP ${swap_used}M"

exit 0
