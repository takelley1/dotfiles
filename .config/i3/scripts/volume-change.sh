#!/usr/bin/env dash
#
# Increases/Decreases volume, then checks to see if L and R channels
#   are equal.
# If channels are not equal, forces R channel to equal L channel.
#

if [ "${1}" = "up" ]; then
    amixer sset Master,0 1%+,1%+ >"/dev/null" 2>&1
elif [ "${1}" = "down" ]; then
    amixer sset Master,0 1%-,1%- >"/dev/null" 2>&1
else
    printf "%s\n" "Invalid argument! Must be \"up\" or \"down\"."
    exit 1
fi

vol="$(amixer get Master | awk -F'[][]' '/[[:digit:]]+%/ {gsub(/%/,""); print $2}')"
L="$(printf "%s\n" "${vol}" | head -1)"
R="$(printf "%s\n" "${vol}" | tail -1)"

if [ "${L}" != "${R}" ]; then
    amixer sset Master,0 "${L}"%,"${L}"% >"/dev/null" 2>&1
fi

exit 0
