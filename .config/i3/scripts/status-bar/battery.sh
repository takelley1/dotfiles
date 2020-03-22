#!/bin/bash

# Print battery percentage and estimated time remaining to full charge
# or depletion.

# Currently the Perl script is being used instead of this one due to
# this script's lack of colors.

percent=$(acpi -b | grep -Eo '[0-9]{1,3}%')
remaining=$(printf "%s\n" "($(acpi -b | grep -Eo '[0-9]{2}:[0-9]{2}:[0-9]{2}'))")
status=$(acpi -b | grep -Eo "(Charging|Discharging)")

text=$(printf "%s " "${percent}" "${remaining}")

if [[ "${status}" == "Charging" ]]; then
    text=$(printf "%s" "${text}" "CHRG")
fi

if [[ -n $(pacman -Q otf-font-awesome) ]]; then
    printf " %s\n" "  $text"
else
    printf " %s\n" "BAT $text"
fi

exit 0
