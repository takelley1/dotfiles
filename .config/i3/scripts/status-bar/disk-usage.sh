#!/usr/bin/env dash

# Status bar script for printing the amount of gigabytes free in the root partition.

# Font-Awesome 
# Emoji U+1F5C3 🗃️
icon="🗃️"

disk_free="$(df --human-readable --local / | awk '{if(NR==2) print $4}')"

printf "%s\n" "${icon} ${disk_free}"

exit 0
