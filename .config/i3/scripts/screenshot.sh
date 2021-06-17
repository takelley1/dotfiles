#!/usr/bin/env dash
#
# Takes a screenshot, compresses it, and saves it to the NFS share.
# Requires pngcrush, ImageMagick, and optionally dunst for notifications.
#
set -eu

time="$(date +%Y-%m-%d_%H:%M:%S)"
hostname="$(hostname)"
screenshot="$(mktemp)"

import -window root "${screenshot}.png"
pngcrush -s "${screenshot}.png" "${HOME}/pictures/misc_pictures/screenshots/polaris_laptop/${time}_${hostname}_screenshot.png"
rm -f -- "${screenshot}.png"

notify-send -u low "Saved screenshot to ${HOME}/pictures/misc_pictures/screenshots/polaris_laptop/${time}_${hostname}_screenshot.png."

exit 0
