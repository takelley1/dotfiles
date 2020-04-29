#!/bin/bash

# Status bar script for printing the total number of packages on the system.

# Font-Awesome f49e  

# Show Font-Awesome icons on Arch-based distros, use text everywhere else.
if [[ -x "/usr/bin/pacman" ]]; then
  if [[ -n $(pacman -Q otf-font-awesome) ]]; then
    printf "%s\n" " $(pacman -Q | wc -l)"
  else
    printf "%s\n" "PKGs $(pacman -Q | wc -l)"
  fi

elif [[ -x "/usr/bin/apt" ]]; then
  printf "%s\n" "PKGs $(dpkg-query --list | wc -l)"
fi

exit 0
