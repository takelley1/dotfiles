#!/bin/bash

# Status bar script that notifies the user of a high CPU temperature.

# Don't run on phobos
if [[ ${HOSTNAME} == "phobos" ]]; then
    exit 0
fi

# Get the current temp from a file, which was written to by the cpu-temp.py script.
temp=$(cat /tmp/cputemp)

#elif [[ ${HOSTNAME} == "tethys" ]]; then
    #temp=$(sensors -u | grep -A 1 'Package id 0' | tail -1 | awk '{print $2}' | cut -f 1 -d '.')
#else
    #temp=$(sensors -u | grep 'temp1_input' | awk '{print $2}' | cut -f 1 -d '.')
#fi

if [[ ${temp} -gt 90 ]]; then
    notify-send -u critical "Suspending system due to CPU temp! (${temp}°C)"
    systemctl suspend
    exit 0
elif [[ ${temp} -gt 85 ]]; then
    notify-send -u critical "CPU is getting VERY hot! (${temp}°C)"
    exit 0
elif [[ ${temp} -gt 80 ]]; then
    notify-send "CPU is getting hot! (${temp}°C)"
    exit 0
fi

exit 0
