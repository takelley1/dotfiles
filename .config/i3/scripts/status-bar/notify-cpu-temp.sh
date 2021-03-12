#!/usr/bin/env dash
#
# Status bar script that notifies the user of a high CPU temperature.

# Get the current temp from a file, which was written to by the
#   cpu-temp.py script.
temp="$(cat "/tmp/cputemp")"

if [ "${temp}" -ge 87 ]; then
    notify-send -u low "CPU is getting hot! (${temp}°C)"
elif [ "${temp}" -ge 89 ]; then
    notify-send "CPU is getting VERY hot! (${temp}°C)"
elif [ "${temp}" -ge 91 ]; then
    notify-send -u critical "Suspending system due to CPU temp! (${temp}°C)"
    sleep 2s
    systemctl suspend &
fi
