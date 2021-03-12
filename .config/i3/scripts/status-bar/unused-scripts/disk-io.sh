#!/usr/bin/env dash
#
# Status bar script for printing the amount of data incoming and
#   outgoing from all local disk interfaces.
# This script is intended to be used on the secondary status bar, so
#   keeyping the output as short as possible is not an issue.
#
#  fa-database [&#xf1c0;]
#  fa-pencil-square-o [&#xf044;]
#  fa-book [&#xf02d;]

# Polling period.
interval=10

# This is for displaying multiple disks' statsus simultaneously #######################
## Count the number of disks in iostat output
#num_disks="$(iostat -hdz -o JSON | jq '.sysstat.hosts[0].statistics[0]' | grep -c 'disk_device')"

## Remove the first set of results from iostat, since those stats start
##   from bootup rather than 10 seconds ago.
#stats=$(iostat -hd 10 2 | sed -e "1,$((3+"${num_disks}"))s/.*//g" -e "/^$/d")

#for i in $(seq 1 "${num_disks}"); do
    #kb_read="$(printf "%s\n" "${stats}" | awk '/[0-9]+k/ {print $2}' | sed -n "${i}"p)"
    #kb_written="$(printf "%s\n" "${stats}" | awk '/[0-9]+k/ {print $3}' | sed -n "${i}"p)"
#done
#######################################################################################

# Remove the first set of results from iostat with sed, since those stats start
#   from bootup rather than $interval seconds ago.
stats=$(iostat -d "${interval}" 2 | sed -e "1,5s/.*//g" -e "/^$/d")
kb_read="$(printf "%s\n" "${stats}" | awk '/[0-9]+/ {print $2}' | head -1)"
kb_written="$(printf "%s\n" "${stats}" | awk '/[0-9]+/ {print $3}' | head -1)"

if [ -n "$(ls /usr/share/fonts/OTF/Font\ Awesome*.otf)" ]; then
    symbol=""
    read_symbol=""
    write_symbol=""
else
    symbol="DISK-IO"
    read_symbol="R"
    write_symbol="W"
fi

printf "%s\n" "${symbol} ${kb_read} K ${read_symbol}  ${kb_written} K ${write_symbol}"

exit 0
