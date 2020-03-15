#!/bin/bash
echo '5' > /tmp/redshift-brightness

# kill any existing redshift processes
killall redshift-gtk

# set new redshift brightness
redshift-gtk -r -t 6500:3000 -b .5:.5 -l 39:-76 &

exit 0
