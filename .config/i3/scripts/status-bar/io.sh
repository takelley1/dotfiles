#!/bin/bash

# Status bar script for printing the "wa" field, as seen in the `top` command to get I/O use estimate.

# Emoji U+1F4BD 💽
# Font-Awesome f252 

io_wa=$(top -b | head -3 | awk '{print $10}' | tail -1)

# Hide disk IO if it's zero.
#[[ "${io_wa}" == "0.0" ]] && exit 0

# Add a leading zero.
if [[ $(echo "${io_wa}" | cut -f 1 -d '.') -lt 10 ]]; then
  io_wa=$(printf "%s\n" "0${io_wa}")
fi

# Show Font-Awesome icons on Arch-based distros, use text everywhere else.
if [[ -n $(pacman -Q otf-font-awesome) ]]; then
  printf "%s\n" " ${io_wa}"
else
  printf "%s\n" "WA ${io_wa}"
fi

exit 0
