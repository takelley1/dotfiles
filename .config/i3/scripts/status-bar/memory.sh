#!/usr/bin/env dash

# Status bar script for printing the current amount of usable RAM remaining.

# Emoji U+1F9E0 🧠
# Font-Awesome f538 
# Nerd Fonts f85a 

icon="🐏"

free="$(free --human | awk '{gsub(/i/,"");if(NR==2) print $7}')"

printf "%s\n" "${icon} ${free}"

exit 0
