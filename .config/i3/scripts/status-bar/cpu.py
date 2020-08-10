#!/usr/bin/env python
#
# Status bar script for printing the current usage of each CPU core.
#
# Usage is expressed in increments of 10, so a core value of "05" means
#   the core is 50% used.

import sys
import psutil


def main():
    core_list = []
    # Break up the tuple containing the usage of each CPU core.
    for core_percent in psutil.cpu_percent(interval=2, percpu=True):
        core_percent = round(core_percent)

        # Add leading zeroes so all numbers are three digits.
        core_percent = ('{:03d}'.format(core_percent))

        # Remove trailing digit to make more compact.
        core_percent = str(core_percent)
        core_percent = '{:.2}'.format(core_percent)

        # Create a list using the rounded values.
        core_list.append(core_percent)

    # Format output.
    core_list = str(core_list)
    core_list = core_list.replace("'", "")
    core_list = core_list.replace('[', '')
    core_list = core_list.replace(']', '')
    core_list = core_list.replace(']', '')

    print('', core_list)
    sys.exit(0)


if __name__ == '__main__':
    main()
