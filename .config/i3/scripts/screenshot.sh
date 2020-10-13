#!/usr/bin/env dash
#
# Takes a screenshot, compresses it, and saves it to ~/Pictures.
#
# Requires pngcrush, ImageMagick, and optionally dunst for notifications.
#
set -eu

time="$(date +%Y-%m-%d_%H:%M:%S)"
hostname="$(hostname)"

import -window root "/tmp/screenshot_${time}.png"
notify-send -u low "Saved screenshot to ${HOME}/Pictures/${time}_${hostname}_screenshot.png."
pngcrush -s "/tmp/screenshot_${time}.png" "${HOME}/Pictures/${time}_${hostname}_screenshot.png"
rm -f -- "/tmp/screenshot_${time}.png"

exit 0
