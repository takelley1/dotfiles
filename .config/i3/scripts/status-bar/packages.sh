#!/usr/bin/env dash
#
# Status bar script for printing the total number of packages on the system.
# The number of packages requiring updates is also shown.
#
# Font-Awesome f49e 
# Font-Awesome  fa-arrow-circle-up [&#xf0aa;]

if [ -x "/usr/bin/pacman" ]; then

    updates=$(checkupdates 2>/dev/null | wc -l)

    # Show Font-Awesome icons if possible, use text everywhere else.
    if [ -n "$(ls /usr/share/fonts/OTF/Font\ Awesome*.otf)" ]; then
        pkg_symbol=""
        update_symbol="  "
    else
        pkg_symbol="PKGs"
        update_symbol=" ^ "
    fi

    # If there aren't any updates, make the relevant variables empty.
    if [ "${updates}" -eq 0 ]; then
        updates=""
        update_symbol=""
    fi

    printf "%s\n" "${pkg_symbol} $(pacman -Q | wc -l)${update_symbol}${updates}"

elif [ -x "/usr/bin/apt" ]; then
    printf "%s\n" "PKGs $(dpkg-query --list | wc -l)"
fi

exit 0
