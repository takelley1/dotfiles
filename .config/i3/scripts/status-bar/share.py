#!/bin/python

# Status bar script for printing the amount of gigabytes free in the network share, assuming it's mounted to /mnt/tank/share/documents.

# Font-Awesome f6ff 

import sys
import psutil

def main():
    # Get free space in bytes
    disk = psutil.disk_usage('/mnt/tank/share/documents').free
    # Convert to TB
    disk = disk / (1024**4)
    disk = round(disk, 3)

    print(' ' + str(disk) + "T")

    sys.exit(0)

if __name__ == '__main__':
    main()
