#!/bin/bash

BRIGHT=$(xrandr --verbose | grep -i brightness | cut -c 14-19 | head -1)
BRIGHT_UP=$(echo $BRIGHT + 0.1 | bc)

xrandr --output HDMI-0 --brightness $BRIGHT_UP
xrandr --output DP-1 --brightness $BRIGHT_UP
xrandr --output DVI-I-1 --brightness $BRIGHT_UP

exit 0
