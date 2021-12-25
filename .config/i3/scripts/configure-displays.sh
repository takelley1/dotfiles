#!/usr/bin/env bash
# Correctly configures the desktop displays.

xrandr --auto

# The number of the DisplayPort displays changes. However, the center monitor
#   will always have the higher number.
displayport_output_lower="$(xrandr --listmonitors | xrandr --listmonitors | awk '/DisplayPort/ {print $NF}' | sort -n | head -1)"
displayport_output_higher="$(xrandr --listmonitors | xrandr --listmonitors | awk '/DisplayPort/ {print $NF}' | sort -r | head -1)"

xrandr --output \
    "${displayport_output_lower}" \
    --left-of "${displayport_output_higher}"
xrandr --output \
    "${displayport_output_higher}" \
    --primary

xrandr --output HDMI-A-0 --right-of "${displayport_output_higher}"
xrandr --output eDP --right-of HDMI-A-0
