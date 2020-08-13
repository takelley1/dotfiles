#!/usr/bin/env python
#
# Print battery percentage and estimated time remaining to full charge or
#   depletion.

import sys
import psutil


# Convert seconds to HH:mm format.
def secs2hours(secs):
    MM, SS = divmod(secs, 60)
    HH, MM = divmod(MM, 60)
    return "%02d:%02d" % (HH, MM)


def main():
    # Get battery information.
    battery = psutil.sensors_battery()

    # Exit quietly if no battery is present.
    if not hasattr(battery, "percent"):
        sys.exit(0)

    # Round remaining percent to nearest whole number.
    percent = round(battery.percent)

    # Convert remaining time to hours and minutes.
    remaining = secs2hours(battery.secsleft)
    # Format remaining time with parentheses.
    remaining = str(remaining)
    remaining = "(" + remaining + ")"

    # Indicate when the battery is being charged.
    if battery.power_plugged:
        plug_icon = ""
    else:
        plug_icon = ""

    # This remaining time is caused by a full battery and is likely
    #   a bug, so don't print anything.
    if remaining == "(-1:59)":
        remaining = ""

    battery_icon = ""
    if percent >= 99:
        output = battery_icon + " FULL"
    else:
        output = battery_icon + " " + str(percent) + "% " + remaining + plug_icon

    print(output)

    # Change color for low-power states.
    # The i3bar protocol uses the third line of the output to specify
    #   color: https://github.com/vivien/i3blocks#format
    if not battery.power_plugged:
        if percent <= 5:
            print("\n#F11712")
        elif percent <= 10:
            print("\n#FF7300")
        elif percent <= 20:
            print("\n#FFF000")

    sys.exit(0)


if __name__ == "__main__":
    main()
