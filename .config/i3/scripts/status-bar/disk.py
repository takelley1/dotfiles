#!/bin/python

# Status bar script for printing the amount of gigabytes free in the root partition.

# Font-Awesome 

import psutil
import sys

def main():
    disk_raw=psutil.disk_usage('/').free # Get free space in bytes
    disk_gb=disk_raw / (1024**3)         # Convert to GB
    disk=round(disk_gb)

    print(" " + str(disk) + "G")

    sys.exit(0)

if __name__ == '__main__':
    main()
