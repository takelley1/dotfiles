#!/usr/bin/env dash
#
# Status bar script for printing the total number of packages on the system.
# The number of packages requiring updates is also shown.

# Emoji U+1F4E6 📦
icon_packages="📦"
# Emoji U+2B06  ⬆️
icon_updates="⬆️"

if [ -x "/usr/bin/pacman" ]; then

    updates=$(checkupdates 2>/dev/null | wc -l)

    # If there aren't any updates, make the relevant variables empty.
    if [ "${updates}" -eq 0 ]; then
        updates=""
        icon_updates=""
    fi

    printf "%s\n" "${icon_packages} $(pacman -Q | wc -l) ${icon_updates}${updates}"

elif [ -x "/usr/bin/apt" ]; then
    printf "%s\n" "PKGs $(dpkg-query --list | wc -l)"
fi

exit 0
