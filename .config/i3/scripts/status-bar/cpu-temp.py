#!/usr/bin/env python
#
# Status bar script for printing the current CPU package temperature.
#
# Emoji U+1F321 🌡️
# Font-Awesome f2c9 

import sys
import os
import psutil

def main():
    temp = psutil.sensors_temperatures()
    temp = temp.get('coretemp')[0].current
    temp = round(temp)
    temp = str(temp)

    print(' ' + temp + '°C')

    # Write the current temperature to a file for notify-cpu-temp.sh to use.
    with open('/tmp/cputemp', mode='w') as file:
        file.write(temp + '\n')
        file.close

    sys.exit(0)

if __name__ == '__main__':
    main()
