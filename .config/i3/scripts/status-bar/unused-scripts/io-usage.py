#!/usr/bin/env python
#
# Status bar script for printing the amount of data incoming and
#   outgoing from all local disk interfaces.
# This script is intended to be used on the secondary status bar, so
#   keeyping the output as short as possible is not an issue.
#
#  fa-database [&#xf1c0;]
#  fa-pencil-square-o [&#xf044;]
#  fa-book [&#xf02d;]

import time
import psutil

# Get starting values.
io = psutil.disk_io_counters("/")["nvme0n1"]
start_bytes_read = io.read_bytes
start_bytes_write = io.write_bytes

time.sleep(10)

# Get ending values.
io = psutil.disk_io_counters("/")["nvme0n1"]
end_bytes_read = io.read_bytes
end_bytes_write = io.write_bytes

# Calculate delta.
bytes_read = end_bytes_read - start_bytes_read
bytes_write = end_bytes_write - start_bytes_write

# Determine which units to use and convert.
kb_unit = 1024
mb_unit = 1024 ** 2
gb_unit = 1024 ** 3

if bytes_read > gb_unit:
    data_read = bytes_read / gb_unit
    read_unit = "G"
elif bytes_read > mb_unit:
    data_read = bytes_read / mb_unit
    read_unit = "M"
elif bytes_read > kb_unit:
    data_read = bytes_read / kb_unit
    read_unit = "K"
else:
    data_read = bytes_read
    read_unit = "B"

if bytes_write > gb_unit:
    data_write = bytes_write / gb_unit
    write_unit = "G"
elif bytes_write > mb_unit:
    data_write = bytes_write / mb_unit
    write_unit = "M"
elif bytes_write > kb_unit:
    data_write = bytes_write / kb_unit
    write_unit = "K"
else:
    data_write = bytes_write
    write_unit = "B"

# Round and print.
data_read = str(round(data_read, 2))
data_write = str(round(data_write, 2))

print("  " + data_read + " " + read_unit + "  " + data_write + " " + write_unit + " ")
