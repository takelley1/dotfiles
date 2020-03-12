#!/bin/bash

# Status bar script for printing the total number of packages on the system.

if [[ -x "/usr/bin/pacman" ]]; then
    printf "%s\n" " $(pacman -Q | wc -l)"

elif [[ -x "/usr/bin/apt" ]]; then
    printf "%s\n" " $(dpkg-query --list | wc -l)"
fi

exit 0
