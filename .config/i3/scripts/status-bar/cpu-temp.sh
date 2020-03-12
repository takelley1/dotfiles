#!/bin/bash

# Status bar script for printing the current CPU package temperature.

if [[ ${HOSTNAME} == "deimos" ]] || [[ ${HOSTNAME} == "phobos" ]]; then

    temp=$(sensors -u | grep 'temp1_input' | awk '{print $2}' | cut -f 1 -d '.')
    printf "%s\n" " ${temp}°C"


elif [[ ${HOSTNAME} == "tethys" ]]; then

    temp=$(sensors -u | grep -A 1 'Package id 0' | tail -1 | awk '{print $2}' | cut -f 1 -d '.')
    printf "%s\n" " ${temp}°C"

fi

exit 0
