#!/bin/bash

# status bar script for obtaining the current screen brightness

if [ $(hostname) == "deimos" ]
then
	echo '' $(brightnessctl | grep -o '[0-9]*%')

elif [ $(hostname) == "phobos" ]
then
	echo '' $(brightnessctl | grep -o '[0-9]*%')

elif [ $(hostname) == "tethys" ]
then
	echo ' ' $(cat /tmp/redshift-brightness)"0%"
fi

exit 0
