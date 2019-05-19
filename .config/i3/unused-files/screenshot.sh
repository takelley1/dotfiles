#!/bin/bash


import -window root ~/latest-screenshot_$(date +%H:%M:%S_%d-%m-%Y).png

mv ~/latest-screenshot*.png ~/Pictures/misc_images/screenshots/uby-desktop/ 

exit 0
