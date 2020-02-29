#!/bin/bash

# status bar script for obtaining the total number of packages on the system

if [ $(hostname) == "deimos" ]
then
	echo ' ' $(pacman -Q | wc -l)

elif [ $(hostname) == "phobos" ]
then
	echo ' ' $(dpkg-query --list | wc -l)

elif [ $(hostname) == "tethys" ]
then
	echo ' ' $(pacman -Q | wc -l)
fi

exit 0
