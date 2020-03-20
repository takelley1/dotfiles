#!/bin/bash

# Status bar script for printing the amount of gigabytes free in the root partition.

# Font-Awesome 

disk_free=$(df -h / | awk '{print $4}' | tail -1)

# Show Font-Awesome icons on Arch-based distros, use text everywhere else.
[[ -x "/usr/bin/pacman" ]] && printf "%s\n" " ${disk_free}" || printf "%s\n" "DSK ${disk_free}"

exit 0
