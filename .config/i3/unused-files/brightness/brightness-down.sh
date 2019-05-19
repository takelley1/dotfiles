#!/bin/bash

# kill any running redshift processes, as it will reset screen brightness
#ps ax | grep redshift | cut -c 1-5 | xargs kill &> /dev/null

# get current screen brightness
BRIGHT=$(xrandr --verbose | grep -i brightness | cut -c 14-19 | head -1)

# modify brightness
BRIGHT_DOWN=$(echo $BRIGHT - 0.1 | bc)

# set new brightness
xrandr --output HDMI-0 --brightness $BRIGHT_DOWN
xrandr --output DP-1 --brightness $BRIGHT_DOWN
xrandr --output DVI-I-1 --brightness $BRIGHT_DOWN

exit 0
