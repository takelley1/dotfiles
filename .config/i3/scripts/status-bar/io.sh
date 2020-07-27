#!/usr/bin/env dash

# Status bar script for printing the "wa" field, as seen in the `top` command to get I/O use estimate.

# Emoji U+1F4BD 💽
# Font-Awesome f252 

io_wa=$(top -b | head -3 | awk '{print $10}' | tail -1)

# Hide disk IO if it's zero.
#[[ "${io_wa}" == "0.0" ]] && exit 0

# Show Font-Awesome icons on Arch-based distros, use text everywhere else.
if [ -e "/usr/share/fonts/OTF/Font Awesome 5 Free-Solid-900.otf" ]; then
  # Pad with leading zeros.
  printf "%s%04.1f\n" " " "${io_wa}"
else
  printf "%s%04.1f\n" "WA " "${io_wa}"
fi

exit 0
