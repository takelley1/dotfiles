#!/bin/bash

if [ $(hostname) == "deimos" ]
then
	echo '' $(sensors -u | grep temp1_input | awk {'print $2'} | cut -f 1 -d '.')'°C'

elif [ $(hostname) == "tethys" ]
then
	echo ' ' $(sensors -u | grep -A 1 'Package id 0' | tail -1 | awk {'print $2'} | cut -f 1 -d '.')'°C'
fi


