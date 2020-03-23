#!/bin/python

# Print battery percentage and estimated time remaining to full charge or
# depletion.

import psutil
import os
import sys

# Don't run on Tethys, since it doesn't have a battery.
if os.uname().nodename == 'tethys':
    sys.exit(0)

def secs2hours(secs): # Convert seconds to HH:mm format.
    mm, ss = divmod(secs, 60)
    hh, mm = divmod(mm, 60)
    return "%02d:%02d" % (hh, mm)

def main():
    batt=psutil.sensors_battery() # Get battery information.

    # Round remaining percent to nearest whole number.
    percent=round(batt.percent) 
    remaining=secs2hours(batt.secsleft)
    output=(str(percent) + '% ' + '(' + (str(remaining) + ')' ))

    if batt.power_plugged == False:
        output=output + ' NOT_CHARGING'
    else:
        output=output + ' CHARGING'
    print(output)

if __name__ == '__main__':
    main()
