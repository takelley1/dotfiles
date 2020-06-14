#!/bin/dash

# Status bar script for printing the total number of packages on the system.
# The number of packages that require updates is shown in parenthesis (requires passwordless sudo for pacman).

# Font-Awesome f49e 

# Show Font-Awesome icons on Arch-based distros, use text everywhere else.
if [ -x "/usr/bin/pacman" ]; then

  updates=$(sudo pacman -Sy >/dev/null 2>&1 && sudo pacman -Qu | wc -l)

  # Add parenthesis around the update number if there are updates to apply.
  if [ "${updates}" -gt 0 ]; then
    updates=" (${updates})"
  else
  # If there aren't any updates, make sure the variable is empty.
    updates=""
  fi

  if [ -n "$(pacman -Q otf-font-awesome)" ]; then
    printf "%s\n" " $(pacman -Q | wc -l)${updates}"
  else
    printf "%s\n" "PKGs $(pacman -Q | wc -l)${updates}"
  fi

elif [ -x "/usr/bin/apt" ]; then
  printf "%s\n" "PKGs $(dpkg-query --list | wc -l)"
fi

exit 0
