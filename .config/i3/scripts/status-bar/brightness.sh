#!/bin/bash

# Status bar script for printing the current screen brightness.

# Emoji U+1F506 🔆
# Font-Awesome f185 

# Show Font-Awesome icons on Arch-based distros, use text everywhere else.
if [[ -x "/usr/bin/pacman" ]]; then

    if [[ ${HOSTNAME} == "tethys" ]]; then
	printf "%s\n" " $(cat /tmp/redshift-brightness)0%"
    else
	printf "%s\n" " $(brightnessctl | grep -o '[0-9]*%')"
    fi

else
    printf "%s\n" "BRGHT $(brightnessctl | grep -o '[0-9]*%')"
fi

exit 0
