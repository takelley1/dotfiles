#!/bin/bash

# Status bar script for printing the amount of gigabytes free in the root partition.

# Font-Awesome 

# Show Font-Awesome icons on Arch-based distros, use text everywhere else.
if [[ -x "/usr/bin/pacman" ]]; then
    printf "%s\n" " $(df -h / | awk '{print $4}' | tail -1)"
else
    printf "%s\n" "DSK $(df -h / | awk '{print $4}' | tail -1)"
fi

exit 0
