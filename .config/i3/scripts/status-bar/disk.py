#!/usr/bin/env python
#
# Status bar script for printing the amount of gigabytes free in the root partition.
#
# Font-Awesome 

import sys
import psutil

def main():
    # Get free space.
    disk = psutil.disk_usage('/')
    disk_byes = disk.free

    disk_perc = disk.percent
    if disk_perc >= 1:
        disk_perc = round(disk_perc)

    # Convert to GB
    disk_byes = disk_byes / (1024**3)
    disk_byes = round(disk_byes)

    print(' ' + str(disk_byes) + 'G (' + str(disk_perc) + '%)')

    # The i3bar protocol uses the third line of the output to specify
    #   color: https://github.com/vivien/i3blocks#format
    if disk_perc >= 90:
        print('\n#F11712')
    elif disk_perc >= 85:
        print('\n#FF7300')
    elif disk_perc >= 80:
        print('\n#FFF000')

    sys.exit(0)

if __name__ == '__main__':
    main()
