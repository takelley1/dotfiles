#!/usr/bin/env bash

# Status bar script for printing the current system load, as seen in `top`.

# Emoji U+1F4CA 📈
# Font-Awesome f3fd 

load1m=$(awk '{print $1}' /proc/loadavg)
load5m=$(awk '{print $2}' /proc/loadavg)
load15m=$(awk '{print $3}' /proc/loadavg)

# Add a leading zero to each value if under 10.
if [[ $(cut -f 1 -d '.' "${load1m}") -lt 10 ]]; then
  load1m=$(printf "%s\n" "0${load1m}")
fi
if [[ $(cut -f 1 -d '.' "${load5m}") -lt 10 ]]; then
  load5m=$(printf "%s\n" "0${load5m}")
fi
if [[ $(cut -f 1 -d '.' "${load15m}") -lt 10 ]]; then
  load15m=$(printf "%s\n" "0${load15m}")
fi

# Show Font-Awesome icons on Arch-based distros, use text everywhere else.
if [[ -n $(pacman -Q otf-font-awesome) ]]; then
  printf "%s\n" " ${load1m}, ${load5m}, ${load15m}"
else
  printf "%s\n" "LOAD ${load1m}, ${load5m}, ${load15m}"
fi

exit 0
