#!/usr/bin/env dash
#
# Takes a screenshot, compresses it, and saves it to ~/Pictures.
#
# Requires pngcrush, scrot, and optionally dunst for notifications.
#
set -eu

time="$(date +%Y-%m-%d_%H:%M:%S)"
hostname="$(hostname)"

sleep 2s
scrot --quality 100 --select --freeze --silent --overwrite "/tmp/screenshot_${time}.png"

pngcrush -s "/tmp/screenshot_${time}.png" "${HOME}/Pictures/${time}_${hostname}_region.png"
rm -f -- "/tmp/screenshot_${time}.png"

notify-send -u low "Saved screenshot to ${HOME}/Pictures/${time}_${hostname}_region.png."

exit 0
