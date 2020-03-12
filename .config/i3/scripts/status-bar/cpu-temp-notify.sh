#!/bin/bash

# Status bar script that notifies the user of a high CPU temperature.

if [[ ${HOSTNAME} == "deimos" ]] || [[ ${HOSTNAME} == "phobos" ]]; then

        temp=$(sensors -u | grep 'temp1_input' | awk '{print $2}' | cut -f 1 -d '.')

        if [[ ${temp} -gt 85 ]]; then
                notify-send -u critical "CPU is getting VERY hot! (${temp}°C)"
	        exit 0
        elif [[ ${temp} -gt 75 ]]; then
                notify-send "CPU is getting hot! (${temp}°C)"
	        exit 0
        fi


elif [[ ${HOSTNAME} == "tethys" ]]; then

	temp=$(sensors -u | grep -A 1 'Package id 0' | tail -1 | awk '{print $2}' | cut -f 1 -d '.')

        if [[ ${temp} -gt 85 ]]; then
                notify-send -u critical "CPU is getting VERY hot! (${temp}°C)"
	        exit 0
        elif [[ ${temp} -gt 75 ]]; then
                notify-send "CPU is getting hot! (${temp}°C)"
	        exit 0
        fi

exit 0
