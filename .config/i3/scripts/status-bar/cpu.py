#!/usr/bin/env python
#
# Status bar script for printing the current usage of the four most
#   active CPU cores/threads.
#
# Usage is expressed on a scale of 1-10, so a value of "5" means
#   a core is 50% used.
#
# Emoji U+1F4BB 💻
# Nerd Fonts e266 

icon = "💻"

import sys
import psutil


def main():
    core_list = []
    # Break up the tuple containing the usage of each CPU core.
    for core_percent in psutil.cpu_percent(interval=3, percpu=True):

        # Round to the nearest tens place.
        core_percent = round(core_percent, -1)
        core_percent = int(core_percent)
        # print("DEBUG: initial: " + str(core_percent))

        # Change two-digit numbers to one digit.
        if core_percent >= 10 and core_percent < 100:
            # print("DEBUG: >10<100: " + str(core_percent))
            core_percent = "{:.1}".format(str(core_percent))
        # Change three-digit numbers (100) to two digits.
        elif core_percent == 100:
            # print("DEBUG: =100: " + str(core_percent))
            core_percent = "{:.2}".format(str(core_percent))

        core_percent = int(core_percent)
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

    print(icon, core_list)
    sys.exit(0)


if __name__ == "__main__":
    main()
