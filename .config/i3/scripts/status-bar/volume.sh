#!/usr/bin/env dash

# Status bar script for printing the current system volume.

# Font-Awesome f028  

# Don't show any volume info on phobos
[ "$(hostname)" = "phobos" ] && exit 0

vol=$(amixer get Master | grep -o '[0-9]*%' | sed -n 1p)

# Show Font-Awesome icons on Arch-based distros, use text everywhere else.
[ -n "$(pacman -Q otf-font-awesome)" ] && printf "%s\n" " ${vol}" || printf "%s\n" "VOL ${vol}"

# Show both L and R channels.
#printf "%s\n " $(amixer get Master | grep -o '[0-9]*%' | tr '\n' ' ' | sed 's/ $//' | tr ' ' '/')"

exit 0
