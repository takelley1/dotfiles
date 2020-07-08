#!/bin/dash
set -eu

# Takes a screenshot, compresses it, and saves it to ~/Pictures.
# Requires pngcrush and ImageMagick.

time="$(date +%Y-%m-%d_%H:%M:%S)"

import -window root "/tmp/screenshot_${time}.png"
notify-send -u low "Saved screenshot to ~/Pictures/${time}_$(hostname)_screenshot.png."
pngcrush -s "/tmp/screenshot_${time}.png" "${HOME}/Pictures/${time}_$(hostname)_screenshot.png"
rm -f "/tmp/screenshot_${time}.png"

exit 0
