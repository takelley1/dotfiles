#!/usr/bin/env dash
#
# Print the current screen brightness.
#
# Emoji U+1F506 🔆
# Emoji U+1F505 🔅
# Font-Awesome f185 
# Nerd Fonts f5df 

icon_bright="🔆"
icon_dim="🔅"

if [ "$(hostname)" = "tethys" ]; then
    brightness="$(cat /tmp/redshift-brightness)0%"
else
    brightness="$(brightnessctl | grep -o '[0-9]*%')"
fi

brightness_raw="$(printf "%s\n" "${brightness}" | tr -d "%")"
if [ "${brightness_raw}" -ge 50 ]; then
    icon="${icon_bright}"
else
    icon="${icon_dim}"
fi

printf "%s\n" "${icon} ${brightness}"

exit 0
