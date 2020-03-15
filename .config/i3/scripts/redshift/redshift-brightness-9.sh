#!/bin/bash
echo '9' > /tmp/redshift-brightness

# kill any existing redshift processes
killall redshift-gtk

# set new redshift brightness
redshift-gtk -r -t 6500:3000 -b .9:.9 -l 39:-76 &

exit 0
