#!/bin/bash

# status bar script that notifies the user of a low battery charge
# this script is called from the i3blocks config file periodically

# get current battery percentage
percent=$(acpi -b | awk '{print $4}' | tr -d '%' | tr -d ',')

# get current battery state (charging or discharging)
state=$(acpi -b | awk '{print $3}')

# don't send a notification if the battery is being charged
if [[ ${state} == 'Charging,' ]]; then
    exit 0
fi

if [[ ${percent} -lt 5 ]]; then
    notify-send -u critical "Battery under 5%"
    exit 0

elif [[ ${percent} -lt 10 ]]; then
    notify-send -u critical "Battery under 10%"
    exit 0

elif [[ ${percent} -lt 15 ]]; then
    notify-send "Battery under 15%"
    exit 0

fi

exit 0
