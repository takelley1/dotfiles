#!/usr/bin/env python
#
# Status bar script for printing the amount of data incoming and
#   outgoing from all network interfaces.
# This script is intended to be used on the secondary status bar, so
#   keeyping the output as short as possible is not an issue.
#
#  fa-angle-double-up [&#xf102;]
#  fa-angle-double-down [&#xf103;]
#   fa-sitemap [&#xf0e8;]

import time
import psutil

# Get starting values.
net = psutil.net_io_counters()
start_bytes_in = net.bytes_recv
start_bytes_out = net.bytes_sent

time.sleep(10)

# Get ending values.
net = psutil.net_io_counters()
end_bytes_in = net.bytes_recv
end_bytes_out = net.bytes_sent

# Calculate delta.
bytes_in = end_bytes_in - start_bytes_in
bytes_out = end_bytes_out - start_bytes_out

# Determine which units to use and convert.
kb_unit = 1024
mb_unit = 1024 ** 2
gb_unit = 1024 ** 3

if bytes_in > gb_unit:
    data_in = bytes_in / gb_unit
    in_unit = "GB"
elif bytes_in > mb_unit:
    data_in = bytes_in / mb_unit
    in_unit = "M"
elif bytes_in > kb_unit:
    data_in = bytes_in / kb_unit
    in_unit = "K"
else:
    data_in = bytes_in
    in_unit = "B"

if bytes_out > gb_unit:
    data_out = bytes_out / gb_unit
    out_unit = "G"
elif bytes_out > mb_unit:
    data_out = bytes_out / mb_unit
    out_unit = "M"
elif bytes_out > kb_unit:
    data_out = bytes_out / kb_unit
    out_unit = "K"
else:
    data_out = bytes_out
    out_unit = "B"

# Round and print.
data_in = str(round(data_in, 2))
data_out = str(round(data_out, 2))

print("   " + data_in + in_unit + "   " + data_out + out_unit + " ")
