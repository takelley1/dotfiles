#!/usr/bin/env python
#
# Status bar script for printing the current amount of virtual RAM available in gigabytes.
#
# Emoji U+1F9E0 🧠
# Font-Awesome f538 

import sys
import psutil

def main():
    # Get raw value of virtual memory available.
    ram = psutil.virtual_memory().available
    # Covert to GB.
    ram = ram / (1024 ** 3)
    # Round to one decimal place.
    ram = round(ram, 1)

    print('  ' + str(ram) + 'G')

    sys.exit(0)

if __name__ == '__main__':
    main()
