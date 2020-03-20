#!/bin/bash

# Status bar script for printing the current usage of CPU cores.

# Show aggregate of all CPU cores.
idle=$(top -bn1 | grep '\%Cpu(s)\:' | grep -Eo "[0-9]{1,3}\.[0-9]? id" | cut -f 1 -d '.')
use=$(echo 100 - ${idle} | bc)

if [[ -x "/usr/bin/pacman" ]]; then
    echo  ${use}%
else
    echo CPU ${use}%
fi

# Show all CPU cores individually.
#cores=$(top -b -n 1 -1 | grep "%Cpu" | awk -F',' '{print $4}' | awk -F'.' '{print $1}' | sed 's/^ *//g' | tr -d 'id')
#echo $(for i in ${cores}; do echo 100 - $i | bc; done) | tr ' ' ','

exit 0
