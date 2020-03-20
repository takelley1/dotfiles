#!/bin/bash

# Status bar script for printing the amount of gigabytes free in the root partition.

# Font-Awesome 

disk_free=$(df -h / | awk '{print $4}' | tail -1)

# Show Font-Awesome icons on Arch-based distros, use text everywhere else.
if [[ -x "/usr/bin/pacman" ]]; then
    printf "%s\n" " ${disk_free}"
else
    printf "%s\n" "DSK ${disk_free}"
fi

exit 0
