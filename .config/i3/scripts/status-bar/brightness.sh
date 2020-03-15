#!/bin/bash

# Status bar script for printing the current screen brightness.

if [[ ${HOSTNAME} == "deimos" ]] || [[ ${HOSTNAME} == "phobos" ]]; then
	printf "%s\n" " $(brightnessctl | grep -o '[0-9]*%')"

elif [[ ${HOSTNAME} == "tethys" ]]; then
	printf "%s\n" " $(cat /tmp/redshift-brightness)0%"
fi

exit 0
