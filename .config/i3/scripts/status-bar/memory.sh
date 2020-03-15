#!/bin/bash

# Status bar script for printing the current amount of RAM remaining in gigabits.

# Emoji U+1F9E0 🧠
# Font-Awesome f538 

# Show Font-Awesome icons on Arch-based distros, use text everywhere else.
if [[ -x "/usr/bin/pacman" ]]; then
    printf "%s\n" "  $(free -h | awk '{print $7}' | sed -n 2p | tr -d 'i')"
else
    printf "%s\n" "FREE $(free -h | awk '{print $7}' | sed -n 2p | tr -d 'i')"
fi

exit 0
