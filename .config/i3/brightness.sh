#!/bin/bash

if [ $(hostname) == "deimos" ]
then
	echo '' $(brightnessctl | grep -o '[0-9]*%')

elif [ $(hostname) == "tethys" ]
then
	echo ' ' $(cat /tmp/redshift-brightness)"0%"
fi


