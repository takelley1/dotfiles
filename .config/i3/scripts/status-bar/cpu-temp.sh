#!/bin/bash

# status bar script for obtaining the current CPU package temp

if [ $(hostname) == "deimos" ]
    then
        TEMP=$(sensors -u | grep temp1_input | awk {'print $2'} | cut -f 1 -d '.')
	echo '' $TEMP'°C'

elif [ $(hostname) == "phobos" ]
    then
        TEMP=$(sensors -u | grep temp1_input | awk {'print $2'} | cut -f 1 -d '.')
	echo '' $TEMP'°C'

elif [ $(hostname) == "tethys" ]
    then
	TEMP=$(sensors -u | grep -A 1 'Package id 0' | tail -1 | awk {'print $2'} | cut -f 1 -d '.')
	echo ' ' $TEMP'°C'
fi

exit 0
