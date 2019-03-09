#!/bin/bash

# kill any existing redshift processes
ps ax | grep redshift-gtk | cut -c 1-5 | xargs kill

sleep .1s

# set new redshift brightness
redshift-gtk -r -t 6500:3000 -b .1:.1 &

exit 0
