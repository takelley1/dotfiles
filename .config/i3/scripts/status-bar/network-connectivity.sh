#!/usr/bin/env dash
#
# Status bar script for printing the primary network interface status.
#
# This script is intended to be used on the secondary status bar, so
#   keeyping the output as short as possible is not an issue.

site_check_domain="icanhazip.com"
site_check_url="https://${site_check_domain}"

# Collect interface info.
status="$(networkctl status --lines=0 --no-pager --no-legend)"
interface="$(printf "%s\n" "${status}" | awk '/Address/ {if(NR==2) print $4}')"
gateway_ip="$(printf "%s\n" "${status}" | awk '/Gateway/ {print $2}' | head -1)"

# Determine gateway connectivity.
if ping -c 1 "${gateway_ip}" | grep -q " bytes from ${gateway_ip}"; then
    gateway="UP"
else
    gateway="DOWN"
fi

# Determine internet connectivity.
if ping -c 1 "${site_check_domain}" | grep -q " bytes from "; then
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

printf "%s\n" "${interface} gw:${gateway} web:${internet} proxy:${proxy}"

# Determine coloring using i3bar protocol.
if [ "${proxy}" = "BLK" ] && [ "${internet}" = "UP" ] && [ "${gateway}" = "UP" ]; then
    printf "\n%s\n" "#FFF000" # Yellow
elif [ "${proxy}" = "DOWN" ] || [ "${internet}" = "DOWN" ] || [ "${gateway}" = "DOWN" ]; then
    printf "\n%s\n" "#FF0000" # Red
else
    printf "\n%s\n" "#00FF00" # Green
fi

exit 0
