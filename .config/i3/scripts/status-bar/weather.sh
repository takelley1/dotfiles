#!/usr/bin/env dash
#
# Status bar script for printing the local weather.
#
# Emoji
# Emoji
# Emoji
# See https://github.com/chubin/wttr.in

# Emoji U+1F343 🍃
wind_icon=🍃
precipitation_icon=
humidity_icon=

weather="$(curl "wttr.in?format=%c%f-%w-%h-%p-%m\n")"
wind="$(printf "%s\n" "${weather}" | cut -f 2 -d ' ')

printf "%s\n" "$(curl "wttr.in?format=3")
