#!/bin/bash

# Controls fanspeed on Dell laptops using the i8k package.

# Only run on the Dell laptop.
if [[ ! ${HOSTNAME} == "deimos" ]]; then
  exit 0
fi

# Get the current temp from a file, which was written to by the cpu-temp.py script.
temp=$(cat /tmp/cputemp)

if [[ ${temp} -ge 82 ]]; then
  i8kfan 1 2 &> /dev/null # Turn fan on high
  exit 0

elif [[ ${temp} -ge 75 ]]; then
  i8kfan 1 1 &> /dev/null # Turn fan on low
  exit 0

else
  i8kfan 0 0 &> /dev/null # Turn fan off
  exit 0

fi

exit 0
