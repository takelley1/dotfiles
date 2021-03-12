#!/usr/bin/env python
#
# Status bar script for printing the current usage of the four most
#   active CPU cores/threads.
#
# Emoji U+1F4BB 💻
# Nerd Fonts e266 
icon = "💻"

# If verbose is False, usage is expressed on a scale of 1-10, so a
#   value of "5" means a core is 50% used. Otherwise, regular
#   percentages are used.
verbose = True
# Number of cores to show in output, sorted by usage.
show_cores = 5

import psutil


def main():
    core_list = []
    # Break up the tuple containing the usage of each CPU core.
    for core_percent in psutil.cpu_percent(interval=3, percpu=True):

        if verbose:
            # print("DEBUG: initial: " + str(core_percent))
            core_percent = round(core_percent)
            core_percent = str(core_percent) + "%"

        # Non-verbose formatting:
        else:
            # Round to the nearest tens place.
            core_percent = round(core_percent, -1)
            core_percent = int(core_percent)

            # Change two-digit numbers to one digit.
            if core_percent >= 10 < 100:
                #  print("DEBUG: >10<100: " + str(core_percent))
                core_percent = "{:.1}".format(str(core_percent))
            # Change three-digit numbers (100) to two digits.
            elif core_percent == 100:
                # print("DEBUG: =100: " + str(core_percent))
                core_percent = "{:.2}".format(str(core_percent))

            core_percent = int(core_percent)

        core_list.append(core_percent)

        # Sort list by most active cores.
        core_list.sort(reverse=True)
        # Only show the X most active cores.
        del core_list[show_cores:]

    # Format output.
    core_list = str(core_list)
    core_list = core_list.replace("'", "")
    core_list = core_list.replace("[", "")
    core_list = core_list.replace("]", "")
    core_list = core_list.replace("]", "")

    print(icon, core_list)


if __name__ == "__main__":
    main()
