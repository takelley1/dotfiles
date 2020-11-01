#!/usr/bin/env dash
#
# Status bar script for printing the "wa" field, as seen in the `top`
#   command to get I/O use estimate.
#
# Emoji U+1F4BD 💽
# Font-Awesome f252 

io_wa=$(top -n 1 -b | awk '/id,.*wa,.*hi,.*si/ {print $10}')

# Hide disk IO if it's zero.
#[[ "${io_wa}" == "0.0" ]] && exit 0

# Show Font-Awesome icons if possible, use text everywhere else.
if [ -n "$(ls /usr/share/fonts/OTF/Font\ Awesome*.otf)" ]; then
    symbol=""
else
    symbol="WA"
fi

# Pad with leading zeros.
printf "%s%04.1f\n" "${symbol} " "${io_wa}"

exit 0
