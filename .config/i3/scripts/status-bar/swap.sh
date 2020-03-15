#!/bin/bash

# Status bar script for printing the current swap space usage in megabytes.

# Emoji U+1F504 🔄
# Font-Awesome f56f 

# Show Font-Awesome icons on Arch-based distros, use text everywhere else.
if [[ -x "/usr/bin/pacman" ]]; then
    printf "%s\n" " $(echo $(cat /proc/swaps | awk '{print $4}' | tail -1) / 1000 | bc)M"
else
    printf "%s\n" "SWP $(echo $(cat /proc/swaps | awk '{print $4}' | tail -1) / 1000 | bc)M"
fi

exit 0
