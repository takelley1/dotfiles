#!/bin/bash

# Status bar script for printing the current system volume.

# Font-Awesome f028  

# Show Font-Awesome icons on Arch-based distros, use text everywhere else.
if [[ -x "/usr/bin/pacman" ]]; then
    printf "%s\n" " $(amixer get Master | grep -o '[0-9]*%' | sed -n 1p)"
elif [[ ${HOSTNAME} == "phobos" ]]; then # Don't show any volume info on phobos
    printf "%s\n" ""
else
    printf "%s\n" "VOL $(amixer get Master | grep -o '[0-9]*%' | sed -n 1p)"
fi

# Show both L and R channels.
#printf "%s\n " $(amixer get Master | grep -o '[0-9]*%' | tr '\n' ' ' | sed 's/ $//' | tr ' ' '/')"

exit 0
