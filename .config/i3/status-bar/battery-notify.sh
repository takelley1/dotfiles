#!/bin/bash

# notifies the user of a low battery charge
# this script is called from the i3blocks config file periodically

# get current battery percentage
PERCENT=$(acpi -b | awk {'print $4'} | tr -d '%' | tr -d ',')

if [ $PERCENT -lt 20 ]
then
	notify-send "Battery under 20%"
elif [ $PERCENT -lt 10 ]
then
	notify-send "Battery under 10%"
elif [ $PERCENT -lt 5 ]
then
	notify-send -u critical "BATTERY UNDER 5%"
fi

exit 0
