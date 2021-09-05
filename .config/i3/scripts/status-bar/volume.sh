#!/usr/bin/env dash
#
# Status bar script for printing the current system volume.

# Emoji U+1F50A 🔊
icon_high="🔊"
# Emoji U+1F509 🔉
icon_medium="🔉"
# Emoji U+1F508 🔈
icon_low="🔈"
# Emoji U+1F507 🔇
icon_muted="🔇"

vol=$(amixer get Master | awk -F'[][]' '/[[:digit:]]+%/ {print $2; exit}')

# Remove percentage from volume so we can do some math.
vol_raw="$(printf "%s\n" "${vol}" | tr -d '%')"

if [ "${vol_raw}" -ge 75 ]; then
    icon="${icon_high}"
elif [ "${vol_raw}" -ge 10 ]; then
    icon="${icon_medium}"
elif [ "${vol_raw}" -gt 0 ]; then
    icon="${icon_low}"
else
    icon="${icon_muted}"
fi

printf "%s\n" "${icon} ${vol}"

exit 0

# Show both L and R channels.
#printf "%s\n " $(amixer get Master | grep -o '[0-9]*%' | tr '\n' ' ' | sed 's/ $//' | tr ' ' '/')"
