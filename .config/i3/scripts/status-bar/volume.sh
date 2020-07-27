#!/usr/bin/env dash

# Status bar script for printing the current system volume.

# Font-Awesome f028 

# Don't show any volume info on phobos
if [ "$(hostname)" = "phobos" ]; then
  exit 0
fi

vol=$(amixer get Master | grep -o '[0-9]*%' | sed -n 1p)

# Show Font-Awesome icons if possible, use text everywhere else.
if [ -n "$(ls /usr/share/fonts/OTF/Font\ Awesome*.otf)" ]; then
  printf "%s\n" " ${vol}"
else
  printf "%s\n" "VOL ${vol}"
fi

# Show both L and R channels.
#printf "%s\n " $(amixer get Master | grep -o '[0-9]*%' | tr '\n' ' ' | sed 's/ $//' | tr ' ' '/')"

exit 0
