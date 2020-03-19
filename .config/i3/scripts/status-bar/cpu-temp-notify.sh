#!/bin/bash

# Status bar script that notifies the user of a high CPU temperature.

# Don't run on phobos
if [[ ${HOSTNAME} == "phobos" ]]; then
    exit 0
elif [[ ${HOSTNAME} == "tethys" ]]; then
    temp=$(sensors -u | grep -A 1 'Package id 0' | tail -1 | awk '{print $2}' | cut -f 1 -d '.')
else
    temp=$(sensors -u | grep 'temp1_input' | awk '{print $2}' | cut -f 1 -d '.')
fi

if [[ ${temp} -gt 85 ]]; then
    notify-send -u critical "CPU is getting VERY hot! (${temp}°C)"
    exit 0
elif [[ ${temp} -gt 75 ]]; then
    notify-send "CPU is getting hot! (${temp}°C)"
    exit 0
fi

exit 0
