#!/usr/bin/env python
#
# Status bar script for printing the current swap space usage in
#   megabytes and percentage of total.
#
# Emoji U+1F504 🔄

icon = "🔄"
minimum_usage = 3

import psutil


def main():
    swap_used = psutil.swap_memory().used

    # If the system doesn't have swap, exit.
    if swap_used is None:
        return

    swap_total = psutil.swap_memory().total

    # Convert used swap to MB.
    swap_used = swap_used / (1024 ** 2)
    swap_used = round(swap_used)
    swap_used = str(swap_used)

    # Convert total swap to GB.
    swap_total = swap_total / (1024 ** 3)
    swap_total = round(swap_total, 1)
    swap_total = str(swap_total)

    swap_used_perc = psutil.swap_memory().percent
    swap_used_perc = round(swap_used_perc)

    # If the system is using <X% of swap space, don't print anything and exit.
    if swap_used_perc < minimum_usage:
        return

    swap_used_perc = str(swap_used_perc)
    print(icon + " " + swap_used + "M/" + swap_total + "G (" + swap_used_perc + "%)")
    return


if __name__ == "__main__":
    main()
