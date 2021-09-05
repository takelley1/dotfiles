#!/usr/bin/env dash
#
# Status bar script for printing the amount of gigabytes free in the root partition.

# Emoji U+1F5C3 🗃️
icon="🗃️"
# Whether to print (% used) in addition to gigabytes free.
show_used=1
# Whether to print "free" next to gigabytes free.
verbose=1

df="$(df --human-readable --local /)"
disk_free="$(printf "%s\n" "${df}" | awk 'END{print $4}')"

if [ "${verbose}" -eq 1 ]; then
    free=" free"
else
    free=""
fi

if [ "${show_used}" -eq 1 ]; then
    disk_used="$(printf "%s\n" "${df}" | awk 'END{print $5}')"
    printf "%s\n" "${icon} ${disk_free}${free} (${disk_used} used)"
else
    printf "%s\n" "${icon} ${disk_free}${free}"
fi

exit 0
