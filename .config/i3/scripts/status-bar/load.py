#!/usr/bin/env python
#
# Status bar script for printing the current system load, as seen in `top`.
#
# Emoji U+1F4CA 📈
# Emoji U+2696 ⚖️
# Font-Awesome f3fd 
# Nerd Fonts f9c4 龍

icon = "⚖️"

import sys
import psutil


def main():
    load_tuple = psutil.getloadavg()
    load_list = []

    # Break apart the tuple to add leading zeroes to each number.
    for load in load_tuple:

        # Convert to int, drop decimal.
        load = int(load)
        load = "{:02d}".format(load)

        # Reassemble the values into a list.
        load_list.append(load)

    # Convert the list into a string and remove unnecessary characters.
    load_list = str(load_list)
    load_list = load_list.replace("[", "")
    load_list = load_list.replace("]", "")
    load_list = load_list.replace("'", "")

    print(icon, load_list)

    sys.exit(0)


if __name__ == "__main__":
    main()
