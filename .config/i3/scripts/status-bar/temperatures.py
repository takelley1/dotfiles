#!/usr/bin/env python
#
# Status bar script for printing the current CPU and GPU
#   package temperatures.

# Emoji U+1F321 🌡️
icon = "🌡️"
cpu_temp_name = "thinkpad"
gpu_temp_name = "amdgpu"

import psutil


def main():
    temps = psutil.sensors_temperatures()

    cpu_temp = temps.get(cpu_temp_name)[0].current
    gpu_temp = temps.get(gpu_temp_name)[0].current

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


if __name__ == "__main__":
    main()
