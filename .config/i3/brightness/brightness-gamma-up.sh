#!/bin/bash

# get current screen brightness
BRIGHT=$(xrandr --verbose | grep -i brightness | cut -c 14-19 | head -1)

# get current screen gamma
# gamma is reversed for some reason, so fix it

# blue
BGAMMA_REVERSED=$(xrandr --verbose | grep -i gamma | cut -c 18-20 | head -1)
BGAMMA_REVERSED_OFFSET=$(xrandr --verbose | grep -i gamma | cut -c 19-20 | head -1)
BGAMMA_REVERSED_OFFSET_FIXED=$(echo $GAMMA_REVERSED_OFFSET + 0.1 | bc)
BGAMMA=$(echo $GAMMA_REVERSED - $GAMMA_REVERSED_OFFSET_FIXED | bc)

# green
GGAMMA_REVERSED=$(xrandr --verbose | grep -i gamma | cut -c 18-20 | head -1)
GGAMMA_REVERSED_OFFSET=$(xrandr --verbose | grep -i gamma | cut -c 19-20 | head -1)
GGAMMA_REVERSED_OFFSET_FIXED=$(echo $GAMMA_REVERSED_OFFSET + 0.1 | bc)
GGAMMA=$(echo $GAMMA_REVERSED - $GAMMA_REVERSED_OFFSET_FIXED | bc)

# modify brightness
BRIGHT_UP=$(echo $BRIGHT + 0.1 | bc)

# set new brightness
xrandr --output HDMI-0 --brightness $BRIGHT_UP --gamma $GAMMA
xrandr --output DP-1 --brightness $BRIGHT_UP --gamma $GAMMA
xrandr --output DVI-I-1 --brightness $BRIGHT_UP --gamma $GAMMA

exit 
