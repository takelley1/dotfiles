#!/usr/bin/env dash
#
# Print the current screen brightness.
#
# Emoji U+1F506 🔆
# Font-Awesome f185 
# Nerd Fonts f5df 

# Show Font-Awesome icons if possible, use text everywhere else.
if [ -n "$(ls /usr/share/fonts/OTF/Font\ Awesome*.otf)" ]; then
    symbol=""
else
    symbol="BRGHT"
fi

if [ "$(hostname)" = "tethys" ]; then
    printf "%s\n" "${symbol} $(cat /tmp/redshift-brightness)0%"
else
    printf "%s\n" "${symbol} $(brightnessctl | grep -o '[0-9]*%')"
fi

exit 0
