#!/usr/bin/env bash

# Status bar script for printing the current usage of CPU cores.

# Show aggregate of all CPU cores.
idle=$(top -bn1 | grep '\%Cpu(s)\:' | grep -Eo "[0-9]{1,3}\.[0-9]? id" | cut -f 1 -d '.')
use=$(echo 100 - "${idle}" | bc)

# Add a leading zero if percentage is under 10 so status bar doesn't keep resizing due to
# value varying between one and two digits in length.
[[ ${use} -lt 10 ]] && use=$(echo 0"${use}")

# Use an emoji if user has pacman installed, otherwise use text.
[[ -n $(pacman -Q otf-font-awesome) ]] && echo  "${use}"% || echo CPU "${use}"%

# Show all CPU cores individually.
#cores=$(top -b -n 1 -1 | grep "%Cpu" | awk -F',' '{print $4}' | awk -F'.' '{print $1}' | sed 's/^ *//g' | tr -d 'id')
#echo $(for i in ${cores}; do echo 100 - $i | bc; done) | tr ' ' ','

exit 0
