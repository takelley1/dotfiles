#!/usr/bin/env python

# Print battery percentage and estimated time remaining to full charge or
# depletion.

import psutil
import os
import sys

# Don't run on Tethys, since it doesn't have a battery.
if os.uname().nodename == 'tethys':
    exit(0)

def secs2hours(secs): # Convert seconds to HH:mm format.
    mm, ss = divmod(secs, 60)
    hh, mm = divmod(mm, 60)

    return "%02d:%02d" % (hh, mm)

def main():
    # Get battery information.
    batt = psutil.sensors_battery()

    # Round remaining percent to nearest whole number.
    percent = round(batt.percent)

    # Convert remaining time to hours and minutes.
    remaining = secs2hours(batt.secsleft)
    remaining = str(remaining)

    output=''

    if batt.power_plugged == True:
        output = output + '(CHARGING)'

    # The secs2hours() function returns -1:59 when the battery is full.
    #   If that's the case, don't print the time remaining.
    if remaining == '-1:59':
        output=" " + str(percent) + '% ' + output
    else:
        output=" " + str(percent) + '% (' + (str(remaining) + ')' ) + output

    print(output)

    sys.exit(0)

if __name__ == '__main__':
    main()
