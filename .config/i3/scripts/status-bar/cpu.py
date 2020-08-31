#!/usr/bin/env python
#
# Status bar script for printing the current usage of the four most
#   active CPU cores/threads.
#
# Usage is expressed in increments of 10, so a value of "5" means
#   a core is 50% used.

import sys
import psutil


def main():
    core_list = []
    # Break up the tuple containing the usage of each CPU core.
    for core_percent in psutil.cpu_percent(interval=3, percpu=True):

        core_percent = round(core_percent)
        # Add leading zero so all numbers are two digits.
        core_percent = "{:02d}".format(core_percent)
        # Only show tens place.
        core_percent = "{:.1}".format(core_percent)
        # Create a list using the reformatted values.
        core_list.append(core_percent)

    # Sort list by most active cores.
    core_list.sort(reverse=True)
    # Only show the 4 most active cores.
    del core_list[4:]

    # Format output.
    core_list = str(core_list)
    core_list = core_list.replace("'", "")
    core_list = core_list.replace("[", "")
    core_list = core_list.replace("]", "")
    core_list = core_list.replace("]", "")

    print("", core_list)
    sys.exit(0)


if __name__ == "__main__":
    main()
