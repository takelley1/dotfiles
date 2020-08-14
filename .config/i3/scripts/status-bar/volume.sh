#!/usr/bin/env dash
#
# Status bar script for printing the current system volume.
#
# Font-Awesome f028 

vol=$(amixer get Master | awk -F'[][]' '/[[:digit:]]+%/ {print $2; exit}')

# Show Font-Awesome icons if possible, use text everywhere else.
if [ -n "$(ls /usr/share/fonts/OTF/Font\ Awesome*.otf)" ]; then
    symbol=""
else
    symbol="VOL"
fi

printf "%s\n" "${symbol} ${vol}"

# Show both L and R channels.
#printf "%s\n " $(amixer get Master | grep -o '[0-9]*%' | tr '\n' ' ' | sed 's/ $//' | tr ' ' '/')"

exit 0
