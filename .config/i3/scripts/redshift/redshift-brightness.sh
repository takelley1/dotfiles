#!/usr/bin/env dash

printf "%s\n" "${1}" > "/tmp/redshift-brightness"

# Kill any existing redshift processes.
pkill -U "$(id -u)" -9 -f redshift

# Set new redshift brightness.
redshift-gtk -r -t 6500:3000 -b "${1}":"${1}" -l 39:-76

exit 0
