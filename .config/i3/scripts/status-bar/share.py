#!/usr/bin/env python
#
# Status bar script for printing the amount of gigabytes free in the
#   network share, assuming it's mounted to /mnt/tank/share/documents.
#
# IP of server that we're mounting storage from.
server_ip = "10.0.0.4"
# Location of mounted sorage in local filesystem.
mount_path = "/mnt/tank/storage/documents"
# Whether to print "free" next to gigabytes free.
verbose = True
# Whether to display percentage used of network share.
# This is not useful on ZFS datasets, for example.
show_percent = False
# Display in gigabytes or terabytes. The value you provide will also
#   be used in the output.
unit = "G"
# Emoji U+1F5C4 🗄️
icon = "🗄️"
# When free space drops below this amount, color the output in red.
# Units are in whatever "unit" is above.
alert_thresh = 1000

import os
import psutil


def main():

    # Check server availability.
    shares = os.system("ping -c 1 " + server_ip + " &>/dev/null")
    if shares != 0:
        return 1

    # Get free space in bytes.
    disk = psutil.disk_usage(mount_path)
    disk_bytes = disk.free

    disk_perc = disk.percent
    if disk_perc >= 1:
        disk_perc = round(disk_perc)

    print_color = False
    if unit in ("T", "t", "TB", "Tb", "tb", "tB", "terabytes", "Terabytes"):
        # Convert to TB.
        disk_bytes_t = disk_bytes / (1024 ** 4)
        disk_bytes_t = round(disk_bytes_t, 2)
        output = icon + str(disk_bytes_t) + unit
        if disk_bytes_t <= alert_thresh:
            print_color = True
    elif unit in ("G", "g", "GB", "Gb", "gb", "gB", "gigabytes", "Gigabytes"):
        # Convert to GB.
        disk_bytes_g = disk_bytes / (1024 ** 3)
        disk_bytes_g = round(disk_bytes_g)
        output = icon + str(disk_bytes_g) + unit
        if disk_bytes_g <= alert_thresh:
            print_color = True
    else:
        print("The 'unit' variable has an incorrect value!")
        return 1

    if verbose is True:
        free = " free"
    else:
        free = ""

    if show_percent:
        print(output + free + " (" + str(disk_perc) + "%)")
    else:
        print(output + free)

    # The i3bar protocol uses the third line of the output to specify.
    #   color: https://github.com/vivien/i3blocks#format
    if print_color:
        print("\n#F11712")

    return 0


if __name__ == "__main__":
    main()
