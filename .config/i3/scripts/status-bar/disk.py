#!/bin/python

# Status bar script for printing the amount of gigabytes free in the root partition.

# Font-Awesome 

from psutil import disk_usage
from sys import exit

def main():
    # Get free space in bytes
    disk_raw=disk_usage('/').free
    # Convert to GB
    disk_gb=disk_raw / (1024**3)
    disk=round(disk_gb)

    print(" " + str(disk) + "G")

    exit(0)

if __name__ == '__main__':
    main()
