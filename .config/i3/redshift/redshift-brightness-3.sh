#!/bin/bash

# kill any existing redshift processes
killall redshift-gtk


# set new redshift brightness
redshift-gtk -r -t 6500:3000 -b .3:.3 -l 39:-76 &

exit 0
