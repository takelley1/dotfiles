#!/bin/python

# Print battery percentage and estimated time remaining to full charge or
# depletion.

from psutil import sensors_battery
from os import uname
from sys import exit

# Don't run on Tethys, since it doesn't have a battery.
if uname().nodename == 'tethys':
    exit(0)

def secs2hours(secs): # Convert seconds to HH:mm format.
    mm, ss = divmod(secs, 60)
    hh, mm = divmod(mm, 60)
    return "%02d:%02d" % (hh, mm)

def main():
    # Get battery information.
    batt=sensors_battery()

    # Round remaining percent to nearest whole number.
    percent=round(batt.percent)
    remaining=secs2hours(batt.secsleft)
    output=(str(percent) + '% ' + '(' + (str(remaining) + ')' ))

    if batt.power_plugged == False:
        output=output + ' NOT_CHARGING'
    else:
        output=output + ' CHARGING'
    print(output)
    exit(0)

if __name__ == '__main__':
    main()
