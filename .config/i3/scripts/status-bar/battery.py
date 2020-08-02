#!/usr/bin/env python
#
# Print battery percentage and estimated time remaining to full charge or
#   depletion.

import psutil
import os
import sys

# Convert seconds to HH:mm format.
def secs2hours(secs):
    mm, ss = divmod(secs, 60)
    hh, mm = divmod(mm, 60)
    return '%02d:%02d' % (hh, mm)

def main():
    # Get battery information.
    batt = psutil.sensors_battery()

    # Exit quietly if no battery is present.
    if not hasattr(batt, 'percent'):
        sys.exit(0)

    # Round remaining percent to nearest whole number.
    percent = round(batt.percent)

    # Convert remaining time to hours and minutes.
    remaining = secs2hours(batt.secsleft)
    # Format remaining time with parentheses.
    remaining = str(remaining)
    remaining = '(' + remaining + ')'

    # Indicate when the battery is being charged.
    if batt.power_plugged == True:
        plug = ''
    else:
        plug=''

    # This remaining time is caused by a full battery and is likely
    #   a bug, so don't print anything.
    if remaining == '(-1:59)':
        remaining = ''

    output=''
    if percent >= 99:
        output=output + ' FULL'
    else:
        output=output + ' ' + str(percent) + '% ' + remaining + plug

    print(output)

    # Change color for low-power states.
    # The i3bar protocol uses the third line of the output to specify
    #   color: https://github.com/vivien/i3blocks#format
    if batt.power_plugged == False:
        if percent <= 5:
            print('\n#F11712')
        elif percent <= 10:
            print('\n#FF7300')
        elif percent <= 20:
            print('\n#FFF000')

    sys.exit(0)

if __name__ == '__main__':
    main()
