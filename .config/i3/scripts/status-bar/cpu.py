#!/usr/bin/env python
#
# Status bar script for printing the current usage of the four most
#   active CPU cores/threads.

# Emoji U+1F4BB 💻
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
    for core_percent in psutil.cpu_percent(interval=1, percpu=True):

        if verbose:
            core_percent = round(core_percent)

        # Non-verbose formatting:
        else:
            # Round to the nearest tens place.
            core_percent = round(core_percent, -1)
            core_percent = str(int(core_percent))

            # Change two-digit numbers to one digit.
            if len(core_percent) > 1:
                core_percent = core_percent[:-1]

        core_list.append(core_percent)

        # Sort list by most active cores.
        core_list.sort(reverse=True)
        # Only show the X most active cores.
        del core_list[show_cores:]

    if verbose:
        # Add percent sign.
        core_list_verbose = []
        for item in core_list:
            item = str(item)
            item = item + "%"
            core_list_verbose.append(item)
        core_list_output = core_list_verbose
    else:
        core_list_output = core_list

    core_list_output = " ".join(core_list_output)
    print(icon, core_list_output)


if __name__ == "__main__":
    main()
