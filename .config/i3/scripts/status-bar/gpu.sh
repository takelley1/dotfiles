#!/usr/bin/env dash

# Status bar script for printing the current GPU load, as seen in `radeontop`.

# Emoji 📺 U+1F4FA
icon="📺"

output="$(radeontop --ticks 60 --limit 1 --dump-interval 1 --dump -)"
output_parsed="$(printf "%s\n" "${output}" | awk 'NR==2 {gsub(/,/,""); print $4, $5",", $26, $27}')"

printf "%s %s\n" "${icon}" "${output_parsed}" 2>/dev/null

exit 0
