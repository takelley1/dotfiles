#!/usr/bin/env dash
#
# Status bar script that notifies the user of a low battery charge.
# Requires acpi.

# Get current battery percentage.
percent="$(acpi -b | awk '{gsub(/%/,""); gsub(/,/,""); print $4}' | sort | tail -1)"

# Don't send a notification if the battery is being charged.
if acpi -b | awk '{print $3}' | grep -Eq "^Charging"; then
    exit 0
fi

echo "${percent}"

if [ "${percent}" -le 15 ]; then
    notify-send -u normal "Battery under 15%!"
elif [ "${percent}" -le 10 ]; then
    notify-send -u normal "Battery under 10%!"
elif [ "${percent}" -le 5 ]; then
    notify-send -u normal "Battery under 5%!"
elif [ "${percent}" -le 3 ]; then
    notify-send -u critical "Battery under 3%!"
fi

exit 0
