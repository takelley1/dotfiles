#!/bin/bash

# Status bar script for printing the total number of packages on the system.

# Font-Awesome f49e  

# Show Font-Awesome icons on Arch-based distros, use text everywhere else.
if [[ -x "/usr/bin/pacman" ]]; then
    printf "%s\n" " $(pacman -Q | wc -l)"

elif [[ -x "/usr/bin/apt" ]]; then
    printf "%s\n" "PKGs $(dpkg-query --list | wc -l)"
fi

exit 0
