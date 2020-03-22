#!/bin/bash

# Status bar script for printing the amount of gigabytes free in the network share, assuming it's mounted to /mnt/tank/share.

# Font-Awesome f6ff 

share_free=$(df -h /mnt/tank/share | awk '{print $4}' | tail -1)

# Show Font-Awesome icons on Arch-based distros, use text everywhere else.
[[ -n $(pacman -Q otf-font-awesome) ]] && printf "%s\n" " ${share_free}" || printf "%s\n" "SHARE ${share_free}"

exit 0
