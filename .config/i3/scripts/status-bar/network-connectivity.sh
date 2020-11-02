#!/usr/bin/env dash
#
# Status bar script for printing the primary network interface status.
#
# This script is intended to be used on the secondary status bar, so
#   keeyping the output as short as possible is not an issue.

site_check_domain="icanhazip.com"
site_check_url="https://icanhazip.com"

# Determine correct network interface.
interface="$(ip address show scope global up | awk '{if(NR==1) print $2}')"

# Determine local network connectivity.
if ping -c 1 10.0.0.1 | grep -q "bytes from"; then
    gateway="UP"
else
    gateway="DOWN"
fi

# Determine internet connectivity.
if ping -c 1 "${site_check_domain}" | grep -q "bytes from"; then
    internet="UP"
else
    internet="DOWN"
fi

# Determine proxy state.
if curl --silent "${site_check_url}" 2>"/dev/null" | grep -q "E2Guardian - Unable to load website"; then
    proxy="BLK"
else
    proxy="FWRD"
fi

printf "%s\n" "${interface} gw ${gateway} web ${internet} proxy ${proxy}"

exit 0
