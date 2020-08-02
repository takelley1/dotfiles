#!/usr/bin/env python
#
# Status bar script for printing the amount of gigabytes free in the root partition.
#
# Font-Awesome 

import sys
import psutil

def main():
    # Get free space in bytes
    disk = psutil.disk_usage('/').free
    # Convert to GB
    disk = disk / (1024**3)
    disk = round(disk)

    print(' ' + str(disk) + 'G')

    sys.exit(0)

if __name__ == '__main__':
    main()
