#!/usr/bin/env dash
#
# Status bar script for printing the primary network interface status.
#
# This script is intended to be used on the secondary status bar, so
#   keeping the output short is not a concern.

# Emoji U+1F7E2 🟢
up_icon="🟢"
# Emoji U+1F534 🔴
down_icon="🔴"
# Emoji U+1F6AB 🚫
blocking_icon="🚫"

# Whether to color-code status.
enable_colors=0
# Whether to print the name of the network interface.
print_interface_name=0

gateway_ip="10.0.0.1"
proxy_ip="10.0.0.15"
site_check_domain="icanhazip.com"
site_check_url="https://${site_check_domain}"

# Determine gateway connectivity.
if ping -c 1 "${gateway_ip}" >/dev/null 2>&1; then
    gateway="${up_icon}"
    # Collect interface info only if gateway is up.
    status="$(networkctl status --lines=0 --no-pager --no-legend)"
    if [ "${print_interface_name}" -eq 1 ]; then
        interface="$(printf "%s\n" "${status}" | awk '/Address/ {if(NR==2) print $4 " "}')"
    fi
    gateway_ip="$(printf "%s\n" "${status}" | awk '/Gateway/ {print $2}' | head -1)"
else
    gateway="${down_icon}"
fi

# Determine internet connectivity.
if ping -c 1 "${site_check_domain}" >/dev/null 2>&1; then
    internet="${up_icon}"
else
    internet="${down_icon}"
fi

# Determine proxy state.
if ping -c 1 "${proxy_ip}" >/dev/null 2>&1; then
    if curl --silent "${site_check_url}" 2>/dev/null | \
    grep -q "E2Guardian - Unable to load website"; then
        proxy="${blocking_icon}"
    else
        proxy="${up_icon}"
    fi
else
    proxy="${down_icon}"
fi

printf "%s\n" "${interface}GW${gateway} WEB${internet} PROXY${proxy}"

if [ "${enable_colors}" -eq 1 ]; then

    # Set coloring using i3bar protocol.
    if [ "${proxy}" = "${blocking_icon}" ] \
    && [ "${internet}" = "${up_icon}" ] \
    && [ "${gateway}" = "${up_icon}" ]; then
        printf "\n%s\n" "#FFF000" # Yellow

    elif [ "${proxy}" = "${down_icon}" ] \
    || [ "${internet}" = "${down_icon}" ] \
    || [ "${gateway}" = "${down_icon}" ]; then
        printf "\n%s\n" "#FF0000" # Red

    else
        printf "\n%s\n" "#00FF00" # Green
    fi
fi
