#!/bin/bash

# status bar script for obtaining the current CPU package temp

if [ $(hostname) == "deimos" ]
then
	TEMP=$(sensors -u | grep temp1_input | awk {'print $2'} | cut -f 1 -d '.')
	echo '' $TEMP'°C'
	# if the temperature goes above a certain value, send an alert notification
	# requires the dunst notification daemon to be running
	if [ $TEMP -gt 75 ]
	then
		notify-send "CPU is getting hot! ($TEMP°C)"
		sleep 20s
	fi

elif [ $(hostname) == "phobos" ]
then
	TEMP=$(sensors -u | grep temp1_input | awk {'print $2'} | cut -f 1 -d '.')
	echo '' $TEMP'°C'
	if [ $TEMP -gt 75 ]
	then
		notify-send "CPU is getting hot! ($TEMP°C)"
		sleep 20s
	fi

elif [ $(hostname) == "tethys" ]
then
	TEMP=$(sensors -u | grep -A 1 'Package id 0' | tail -1 | awk {'print $2'} | cut -f 1 -d '.')
	echo ' ' $TEMP'°C'
	if [ $TEMP -gt 75 ]
	then
		notify-send "CPU is getting hot! ($TEMP°C)"
		sleep 20s
	fi
fi

exit 0
