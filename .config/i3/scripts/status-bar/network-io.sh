#!/usr/bin/env dash
#
# Status bar script for printing the amount of data incoming and
#   outgoing from the primary network interface.
# This script is intended to be used on the secondary status bar, so
#   keeyping the output as short as possible is not an issue.
#
# shellcheck disable=1004
#
icon="I"
in_icon=""
out_icon=""

# Determine the correct network interface.
interface="$(ip address show scope global up | awk '{gsub(/:/,""); if(NR==1) print $2}')"
# Gather raw statistics.
stats="$(ifdata -si -bips -so -bops "${interface}")"

# Feed vars into awk script, parse, and format.
printf "%s\n%s\n%s\n%s\n" "${icon}" "${in_icon}" "${out_icon}" "${stats}" | awk \
'
 {if(NR==1)icon=$1}
 {if(NR==2)inicon=$1}
 {if(NR==3)outicon=$1}
 {if(NR==4)inerr=$3 " " $4 " " $5 " " $6 " " $7 " " $8}
 {if(NR==5)inrate=$1}
 {if(NR==6)outerr=$3 " " $4 " " $5 " " $6 " " $7 " " $8}
 {if(NR==7)outrate=$1}
 END \
 {print icon " " inrate "B(" inerr ")" inicon " " outrate "B(" outerr ")" outicon}
'

exit 0
