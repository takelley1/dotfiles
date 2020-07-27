#!/usr/bin/env python

# Print battery percentage and estimated time remaining to full charge or
# depletion.

import psutil
import os
import sys

# Don't run on Tethys, since it doesn't have a battery.
if os.uname().nodename == 'tethys':
    exit(0)

# Convert seconds to HH:mm format.
def secs2hours(secs):
    mm, ss = divmod(secs, 60)
    hh, mm = divmod(mm, 60)
    return '%02d:%02d' % (hh, mm)

def main():
    # Get battery information.
    batt = psutil.sensors_battery()

    # Round remaining percent to nearest whole number.
    percent = round(batt.percent)

    # Convert remaining time to hours and minutes.
    remaining = secs2hours(batt.secsleft)
    remaining = str(remaining)

    output=''

    # Indicate when the battery is being charged.
    if batt.power_plugged == True:
        output = '(+)'

    if percent >= 99:
        output='  FULL'
    else:
        output=' ' + str(percent) + '% (' + (str(remaining) + ')' ) + output

    print(output)

    sys.exit(0)

if __name__ == '__main__':
    main()
