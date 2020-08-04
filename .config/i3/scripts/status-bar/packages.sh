#!/usr/bin/env dash
#
# Status bar script for printing the total number of packages on the system.
# The number of packages that require updates is shown in parentheses.
#   (requires passwordless sudo for pacman).
#
# Font-Awesome f49e 

if [ -x "/usr/bin/pacman" ]; then

  updates=$(checkupdates 2>/dev/null | wc -l)

  # Add parenthesis around the update number if there are updates to apply.
  if [ "${updates}" -gt 0 ]; then
    updates=" (${updates})"
  else
  # If there aren't any updates, make sure the variable is empty.
    updates=""
  fi

  # Show Font-Awesome icons if possible, use text everywhere else.
  if [ -n "$(ls /usr/share/fonts/OTF/Font\ Awesome*.otf)" ]; then
    symbol=""
  else
    symbol="PKGs"
  fi
  printf "%s\n" "${symbol} $(pacman -Q | wc -l)${updates}"

elif [ -x "/usr/bin/apt" ]; then
  printf "%s\n" "PKGs $(dpkg-query --list | wc -l)"
fi

exit 0
