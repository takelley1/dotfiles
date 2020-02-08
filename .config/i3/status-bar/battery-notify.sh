#!/bin/bash

# notifies the user of a low battery charge
# this script is called from the i3blocks config file periodically

# get current battery percentage
PERCENT=$(acpi -b | awk {'print $4'} | tr -d '%' | tr -d ',')

# get current battery state (charging or discharging)
STATE=$(acpi -b | awk {'print $3'})

# don't send a notification if the battery is being charged
if [ $STATE == 'Charging,' ]
  then
    exit 0
fi

if [ $PERCENT -lt 5 ]
  then
    notify-send -u critical "BATTERY UNDER 5%"
    exit 0

elif [ $PERCENT -lt 10 ]
  then
    notify-send "Battery under 10%"
    exit 0

elif [ $PERCENT -lt 20 ]
  then
    notify-send "Battery under 20%"
    exit 0
fi

exit 0
