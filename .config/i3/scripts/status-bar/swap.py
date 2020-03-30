#!/bin/python

# Status bar script for printing the current swap space usage in megabytes and percentage of total.

# Emoji U+1F504 🔄
# Font-Awesome f56f 

import sys
import psutil

def main():
    # Get swap usage in bytes.
    swap_used_raw=psutil.swap_memory().used

    # If the system doesn't have swap, exit.
    if swap_used_raw is None:
        sys.exit(0)

    # Convert to MB
    swap_used_mb=swap_used_raw / (1024**2)
    swap_used=round(swap_used_mb,1)

    # Round down by default if less than 1 MB
    if swap_used < 1:
        swap_used=0

    # Get swap usage in percentage of total swap space.
    swap_used_percent_raw=psutil.swap_memory().percent
    swap_used_percent=round(swap_used_percent_raw)

    print(" " + str(swap_used) + "M (" + str(swap_used_percent) + "%)")

    sys.exit(0)

if __name__ == '__main__':
    main()
