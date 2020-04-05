#!/bin/python

# Status bar script for printing the current usage of each CPU core.

import psutil
import sys
import os

def main():

    core_list=[]

    # Get a list of the current usage of each CPU core.
    for core_percent in psutil.cpu_percent(interval=0.5, percpu=True):
        # Round each value.
        core_percent=round(core_percent)
        # Add leading zeroes to single-digit numbers.
        core_percent=("{:02d}".format(core_percent))
        core_percent=(core_percent + "%")
        # Re-create the list using the rounded values.
        core_list.append(core_percent)

    core_list=str(core_list)

    # Format output.
    os.system('echo ' + core_list + \
            ' | sed -e "s/\[//g"    \
                    -e "s/\]//g"    \
                    -e "s/.*/ &/g" \
                    -e "s/\,/ /g"   \
                    >/tmp/cpu_usage')

    print(open("/tmp/cpu_usage").read())
    sys.exit(0)

if __name__ == '__main__':
    main()
