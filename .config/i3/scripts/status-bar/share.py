#!/usr/bin/env python
#
# Status bar script for printing the amount of gigabytes free in the
#   network share, assuming it's mounted to /mnt/tank/share/documents.
#
# Font-Awesome f6ff 

# Whether to display percentage used of network share.
# This is not useful on ZFS datasets, for example.
show_percent = False
# Display in gigabytes or terabytes. The value you provide will also
#   be used in the output.
unit = "G"
icon = ""
# When free space drops below this amount, color the output in red.
# Units are in gigabytes.
alert_thresh = 1800

import os
import sys
import psutil


def main():

    # Check server availability.
    shares = os.system("ping -c 1 10.0.0.4 &>/dev/null")
    if shares != 0:
        sys.exit(0)

    # Get free space in bytes.
    disk = psutil.disk_usage("/mnt/tank/storage/documents")
    disk_bytes = disk.free

    disk_perc = disk.percent
    if disk_perc >= 1:
        disk_perc = round(disk_perc)

    # Convert to GB.
    disk_bytes_g = disk_bytes / (1024 ** 3)
    disk_bytes_g = round(disk_bytes_g)
    output = icon + str(disk_bytes_g) + unit

    if unit in ("T", "t", "TB", "Tb", "tb", "tB", "terabytes", "Terabytes"):
        # Convert to TB.
        disk_bytes_t = disk_bytes / (1024 ** 4)
        disk_bytes_t = round(disk_bytes_t, 2)
        output = icon + str(disk_bytes_t) + unit
    elif unit not in ("G", "g", "GB", "Gb", "gb", "gB", "gigabytes", "Gigabytes"):
        print("The 'unit' variable has an incorrect value!")
        sys.exit(1)

    if show_percent:
        print(output + " (" + str(disk_perc) + "%)")
    else:
        print(output)

    # The i3bar protocol uses the third line of the output to specify.
    #   color: https://github.com/vivien/i3blocks#format
    if disk_bytes_g <= alert_thresh:
        print("\n#F11712")

    sys.exit(0)


if __name__ == "__main__":
    main()
