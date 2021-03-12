#!/usr/bin/env dash

# Status bar script for printing the current system load, as seen in `top`.
# 100 runs of this script complete in about 0.6s

# Emoji U+1F4CA 📈
# Emoji U+2696 ⚖️
# Font-Awesome f3fd 
# Nerd Fonts f9c4 龍
icon="⚖️"
# Whether to print full info or cut off decimals.
verbose=1

load1m="$(cut -f1 -d' ' /proc/loadavg)"
load5m="$(cut -f2 -d' ' /proc/loadavg)"
load15m="$(cut -f3 -d' ' /proc/loadavg)"

if [ "${verbose}" -eq 1 ]; then
    printf "%s\n" "${icon} ${load1m}, ${load5m}, ${load15m}"
else
    printf "%s %02d, %02d, %02d\n" \
        "${icon}" "${load1m}" "${load5m}" "${load15m}" 2>/dev/null
fi
