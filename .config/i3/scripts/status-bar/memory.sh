#!/usr/bin/env dash
#
# Status bar script for printing the current amount of usable RAM remaining.

# Emoji U+1F9E0 🧠
# Emoji 🐏 U+1F40F
icon="🐏"
verbose=1

free="$(free --si | awk '{if(NR==2) print $7/1000000}')"

if [ "${verbose}" -eq 1 ]; then
    # Show 2 decimal places.
    printf "%s %.2f%s\n" "${icon}" "${free}" "G free"
else
    # Show integer only.
    printf "%s %2d%s\n" "${icon}" "${free}" "G free" 2>/dev/null
fi

exit 0
