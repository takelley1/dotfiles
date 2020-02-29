#!/bin/bash

# status bar script that notifies the user of a high CPU temp
# this script is called from the i3blocks config file periodically

if [ $(hostname) == "deimos" ]
    then
        TEMP=$(sensors -u | grep temp1_input | awk {'print $2'} | cut -f 1 -d '.')
        if [ $TEMP -gt 85 ]
            then
                notify-send "CPU is getting hot! ($TEMP°C)"
	        exit 0
        elif [ $TEMP -gt 75 ]
            then
                notify-send -u critical "CPU is getting VERY hot! ($TEMP°C)"
	        exit 0
        fi

elif [ $(hostname) == "phobos" ]
    then
	TEMP=$(sensors -u | grep temp1_input | awk {'print $2'} | cut -f 1 -d '.')
        if [ $TEMP -gt 85 ]
            then
                notify-send "CPU is getting hot! ($TEMP°C)"
	        exit 0
        elif [ $TEMP -gt 75 ]
            then
                notify-send -u critical "CPU is getting VERY hot! ($TEMP°C)"
	        exit 0
        fi

elif [ $(hostname) == "tethys" ]
    then
	TEMP=$(sensors -u | grep -A 1 'Package id 0' | tail -1 | awk {'print $2'} | cut -f 1 -d '.')
        if [ $TEMP -gt 85 ]
            then
                notify-send "CPU is getting hot! ($TEMP°C)"
	        exit 0
        elif [ $TEMP -gt 75 ]
            then
                notify-send -u critical "CPU is getting VERY hot! ($TEMP°C)"
	        exit 0
        fi

exit 0
