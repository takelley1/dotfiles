#!/bin/bash

# Status bar script for printing the current CPU package temperature.

# Emoji U+1F321 🌡️
# Font-Awesome f2c9 

# Phobos doesn't have any temp monitors.
[[ ${HOSTNAME} == "phobos" ]] && exit 0

# Show Font-Awesome icons on Arch-based distros, use text everywhere else.
if [[ -n $(pacman -Q otf-font-awesome) ]]; then

    if [[ ${HOSTNAME} == "tethys" ]]; then
        temp=$(sensors -u | grep -A 1 'Package id 0' | tail -1 | awk '{print $2}' | cut -f 1 -d '.')
        printf "%s\n" " ${temp}°C"
    else
        temp=$(sensors -u | grep 'temp1_input' | awk '{print $2}' | cut -f 1 -d '.')
        printf "%s\n" " ${temp}°C"
    fi

else
    temp=$(sensors -u | grep 'temp1_input' | awk '{print $2}' | cut -f 1 -d '.')
    printf "%s\n" "CPU ${temp}°C"

fi

exit 0
