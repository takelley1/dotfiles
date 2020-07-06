#!/bin/dash

# Status bar script that notifies the user of a low battery charge.

# Don't run on phobos.
[ "$(hostname)" = "phobos" ] && exit 0

# Get current battery percentage.
percent=$(acpi -b | awk '{print $4}' | tr -d '%' | tr -d ',')

# Get current battery state (charging or discharging).
state=$(acpi -b | awk '{print $3}')

# Don't send a notification if the battery is being charged.
[ "${state}" = 'Charging,' ] && exit 0

if [ "${percent}" -le 3 ]; then
  notify-send -u critical "Battery under 3%"
  exit 0

elif [ "${percent}" -le 5 ]; then
  notify-send -u critical "Battery under 5%"
  exit 0

elif [ "${percent}" -le 10 ]; then
  notify-send "Battery under 10%"
  exit 0
fi

exit 0
