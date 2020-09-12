#!/usr/local/env python

import time
import psutil

# Get starting values.
net = psutil.net_io_counters()
start_bytes_in = net.bytes_recv
start_bytes_out = net.bytes_sent

time.sleep(5)

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

if bytes_in > kb_unit:
    data_in = bytes_in / kb_unit
    in_unit = "K"
elif bytes_in > mb_unit:
    data_in = bytes_in / mb_unit
    in_unit = "M"
elif bytes_in > gb_unit:
    data_in = bytes_in / gb_unit
    in_unit = "G"
else:
    data_in = bytes_in
    in_unit = "B"

if bytes_out > kb_unit:
    data_out = bytes_out / kb_unit
    out_unit = "K"
elif bytes_out > mb_unit:
    data_out = bytes_out / mb_unit
    out_unit = "M"
elif bytes_out > gb_unit:
    data_out = bytes_out / gb_unit
    out_unit = "G"
else:
    data_out = bytes_out
    out_unit = "B"

# Print
data_in = str(round(data_in, 2))
data_out = str(round(data_out, 2))

print(": " + data_in + in_unit + ", : " + data_out + out_unit)
