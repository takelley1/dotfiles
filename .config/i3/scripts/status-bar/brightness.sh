#!/usr/bin/env dash
#
# Print the current screen brightness.

# Emoji U+1F506 🔆
icon_bright="🔆"
# Emoji U+1F505 🔅
icon_dim="🔅"

if [ -r "/tmp/redshift-brightness" ]; then
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
