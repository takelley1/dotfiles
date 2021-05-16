#!/usr/bin/env python
#
# Print battery percentage and estimated time remaining to full charge or
#   depletion.
#
# Emoji U+1F50B 🔋
# Emoji U+1F50C 🔌
# Emoji U+26A1  ⚡

battery_icon = "🔋"
plug_icon = "⚡"

# Percentage battery must reach to be declared full.
full_threshold = 98
# Don't print anything if the battery has reached full_threshold.
hide_when_full = True

import psutil


# Convert seconds to HH:mm format.
def secs2hours(secs):
    MM, _ = divmod(secs, 60)
    HH, MM = divmod(MM, 60)
    return "%02d:%02d" % (HH, MM)


def main():
    # Get battery information.
    battery = psutil.sensors_battery()

    # Exit quietly if no battery is present.
    if not hasattr(battery, "percent"):
        return 1

    # Round remaining percent to nearest whole number.
    percent = round(battery.percent)

    # Convert remaining time to hours and minutes.
    remaining = secs2hours(battery.secsleft)
    # Format remaining time with parentheses.
    remaining = "(" + str(remaining) + ")"

    # Indicate when the battery is being charged.
    if not battery.power_plugged:
        global plug_icon
        plug_icon = ""

    # This remaining time is caused by a full battery and is likely
    #   a bug, so don't print anything.
    if remaining == "(-1:59)":
        remaining = ""

    if percent >= full_threshold:
        if hide_when_full:
            output = ""
        else:
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

    return 0


if __name__ == "__main__":
    main()
