#!/bin/bash

# Status bar script for printing the current swap space usage in megabytes.

# Emoji U+1F504 🔄
# Font-Awesome f56f 

swap_used=$(echo "$(awk '{print $4}' /proc/swaps | tail -1)" / 1000 | bc)

# Show Font-Awesome icons on Arch-based distros, use text everywhere else.
if [[ -n "${swap_used}" ]]; then # Only continue if the system has a swap partition.
    if [[ -n $(pacman -Q otf-font-awesome) ]]; then
        printf "%s\n" " ${swap_used}M"
    else
        printf "%s\n" "SWP ${swap_used}M"
    fi
fi

exit 0
