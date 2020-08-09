#!/usr/bin/env python
#
# Status bar script for printing the amount of gigabytes free in the
#   network share, assuming it's mounted to /mnt/tank/share/documents.
#
# Font-Awesome f6ff 

# Whether to display percentage used of network share.
# This is not useful on ZFS datasets, for example.
show_percent = False

import os
import sys
import psutil


def main():

    # Check server availability.
    shares = os.system('ping -c 1 10.0.0.4 &>/dev/null')
    if shares != 0:
        sys.exit(0)

    # Get free space in bytes.
    disk = psutil.disk_usage('/mnt/tank/share/documents')
    disk_byes = disk.free

    disk_perc = disk.percent
    if disk_perc >= 1:
        disk_perc = round(disk_perc)

    # Convert to TB.
    disk_byes = disk_byes / (1024**4)
    disk_byes = round(disk_byes, 2)

    output = ' ' + str(disk_byes) + 'T'

    if show_percent is False:
        print(output)

    # The i3bar protocol uses the third line of the output to specify.
    #   color: https://github.com/vivien/i3blocks#format
    else:
        print(output + ' (' + str(disk_perc) + '%)')

        if disk_perc >= 80:
            print('\n#F11712')
        elif disk_perc >= 75:
            print('\n#FF7300')
        elif disk_perc >= 70:
            print('\n#FFF000')

    sys.exit(0)


if __name__ == '__main__':
    main()
