#!/usr/bin/env dash
#
# Status bar script for printing the amount of data incoming and
#   outgoing from the primary network interface.
# This script is intended to be used on the secondary status bar, so
#   keeyping the output as short as possible is not an issue.
#
#  fa-angle-double-up [&#xf102;]
#  fa-angle-double-down [&#xf103;]
#   fa-sitemap [&#xf0e8;]

# Polling period.
interval=10

# Reset history.
ifstat --reset >"/dev/null" 2>&1
# Wait to collect data.
sleep "${interval}"s

# Determine correct network interface and grab stats.
interface="$(ip address show scope global up | awk '{gsub(/:/,""); if(NR==1) print $2}')"
stats=$(ifstat --noupdate "${interface}")

packets_in="$(printf "%s\n" "${stats}" | awk '{if(NR==4) print $2}')"
packets_out="$(printf "%s\n" "${stats}" | awk '{if(NR==4) print $4}')"

if [ -n "$(ls /usr/share/fonts/OTF/Font\ Awesome*.otf)" ]; then
    symbol=" "
    in_symbol=""
    out_symbol=""
else
    symbol="NET-IO"
    in_symbol="RX"
    out_symbol="TX"
fi

printf "%s\n" "${symbol} ${packets_in} pkt ${in_symbol}  ${packets_out} pkt ${out_symbol}"

exit 0
