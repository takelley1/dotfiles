#!/usr/bin/env python
#
# Status bar script for printing the current CPU package temperature.
#
# Emoji U+1F321 🌡️
# Font-Awesome f2c9 

import socket
import sys
import psutil


def main():
    temp = psutil.sensors_temperatures()
    hostname = socket.gethostname()

    if hostname == "polaris":
        temp = temp.get("thinkpad")[0].current
    elif hostname == "deimos":
        temp = temp.get("coretemp")[0].current

    temp = round(temp)
    temp = str(temp)

    print(" " + temp + "°C")

    # Write the current temperature to a file for notify-cpu-temp.sh to use.
    with open("/tmp/cputemp", mode="w") as file:
        file.write(temp + "\n")

    sys.exit(0)


if __name__ == "__main__":
    main()
