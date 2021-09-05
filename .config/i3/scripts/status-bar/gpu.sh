#!/usr/bin/env dash
#
# Status bar script for printing the current GPU load, as seen in `radeontop`.

# Emoji 📺 U+1F4FA
icon="📺"

radeontop="$(radeontop --ticks 60 --limit 1 --dump-interval 1 --dump -)"
radeontop_parsed="$(printf "%s\n" "${radeontop}" | awk 'NR==2 {gsub(/,/,""); print $4, $5",", $26, $27}')"

printf "%s %s\n" "${icon}" "${radeontop_parsed}" 2>/dev/null

exit 0
