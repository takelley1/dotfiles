#!/bin/python

# Status bar script for printing the current usage of CPU cores once per second.

from psutil import cpu_percent
from sys import exit

def main():
    percent=cpu_percent(1)
    percent=round(percent)

    if percent < 10:
        print(" 0" + str(percent) + "%")
    else:
        print(" "+ str(percent) + "%")

    exit(0)

if __name__ == '__main__':
    main()
