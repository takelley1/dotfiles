#!/usr/bin/env dash
#
# Status bar script for printing the "wa" field, as seen in the `top`
#   command to get I/O use estimate.

# Emoji U+1F4BD 💽
# Emoji U+23F3 ⏳
icon="⏳"

io_wa=$(top -n 1 -b | awk '/id,.*wa,.*hi,.*si/ {print $10}')

# Pad with leading zeros.
printf "%s%04.1f\n" "${icon} " "${io_wa}"

exit 0
