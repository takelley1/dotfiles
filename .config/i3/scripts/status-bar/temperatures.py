#!/usr/bin/env python
#
# Status bar script for printing the current CPU and GPU
#   package temperatures.
#
# Emoji U+1F321 🌡️
# Font-Awesome f2c9 
# Nerd Fonts f2c9 

icon = "🌡️"

import socket
import sys
import psutil


def main():
    temps = psutil.sensors_temperatures()
    hostname = socket.gethostname()

    if hostname == "polaris":
        cpu_temp = temps.get("thinkpad")[0].current
        gpu_temp = temps.get("amdgpu")[0].current

    elif hostname == "deimos":
        cpu_temp = temps.get("coretemp")[0].current
        gpu_temp = ""

    cpu_temp = round(cpu_temp)
    cpu_temp = str(cpu_temp)

    if gpu_temp == "":
        print(icon + cpu_temp + "°C")
    else:
        gpu_temp = round(gpu_temp)
        gpu_temp = str(gpu_temp)
        print(icon + "CPU: " + cpu_temp + "°C" + ", GPU: " + gpu_temp + "°C")

    # Write the current CPU temperature to a file for notify-cpu-temp.sh to use.
    with open("/tmp/cputemp", mode="w") as file:
        file.write(cpu_temp + "\n")

    sys.exit(0)


if __name__ == "__main__":
    main()
