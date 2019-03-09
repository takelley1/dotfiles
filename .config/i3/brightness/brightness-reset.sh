#!/bin/bash

xrandr --output DP-1 --brightness 1 --gamma 1:1:1 &> /dev/null
xrandr --output DVI-I-1 --brightness 1 --gamma 1:1:1 &> /dev/null
xrandr --output HDMI-0 --brightness 1 --gamma 1:1:1 &> /dev/null

exit 0
