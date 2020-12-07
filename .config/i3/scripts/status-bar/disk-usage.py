#!/usr/bin/env python
#
# Status bar script for printing the amount of gigabytes free in the
#   root partition.
#
# Font-Awesome 
# Emoji U+1F5C4 🗄️

icon = "🗄️"

import sys
import psutil


def main():
    # Get free space.
    disk = psutil.disk_usage("/")
    disk_bytes = disk.free

    disk_perc = disk.percent
    if disk_perc >= 1:
        disk_perc = round(disk_perc)

    # Convert to GB
    disk_bytes = disk_bytes / (1024 ** 3)
    disk_bytes = round(disk_bytes)
    disk_bytes = str(disk_bytes)

    print(icon + disk_bytes + "G (" + str(disk_perc) + "%)")

    # The i3bar protocol uses the third line of the output to specify
    #   color: https://github.com/vivien/i3blocks#format
    if disk_perc >= 90:
        print("\n#F11712")
    elif disk_perc >= 85:
        print("\n#FF7300")
    elif disk_perc >= 75:
        print("\n#FFF000")

    sys.exit(0)


if __name__ == "__main__":
    main()
