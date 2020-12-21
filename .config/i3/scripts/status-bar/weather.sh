#!/usr/bin/env dash
#
# Status bar script for printing the local weather.
#
# See https://github.com/chubin/wttr.in

# Emoji U+1F343 🍃
wind_icon="🍃"
# Emoji U+1F4A7 💧
humidity_icon="💧"

# Check connectivity first.
if curl https://icanhazip.com 2>/dev/stdout | grep -Eq "E2Guardian|Connection refused"; then
    exit 0
else
    weather_full="$(curl -s "wttr.in?format=%c%f-%w-%h\n")"

    wind="$(printf "%s\n" "${weather_full}" | cut -f 2 -d '-')"
    humidity="$(printf "%s\n" "${weather_full}" | cut -f 3 -d '-')"
    weather="$(printf "%s\n" "${weather_full}" | cut -f 1 -d '-')"

    printf "%s\n" "${weather}, ${wind_icon}${wind}, ${humidity_icon}${humidity}"
fi
