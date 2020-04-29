#!/bin/python

# Status bar script for printing the current swap space usage in megabytes and percentage of total.

# Emoji U+1F504 🔄
# Font-Awesome f56f 

import sys
import psutil

def main():
  # Get swap usage in bytes.
  swap_used = psutil.swap_memory().used

  # If the system doesn't have swap, exit.
  if swap_used is None:
    exit(0)

  # Convert to MB
  swap_used = swap_used / (1024**2)
  swap_used = round(swap_used)

  # If the system is using <1M of swap space, exit.
  if swap_used < 1:
    exit(0)

  # Get swap usage in percentage of total swap space.
  swap_used_percent = psutil.swap_memory().percent
  swap_used_percent = round(swap_used_percent)

  print(" " + str(swap_used) + "M (" + str(swap_used_percent) + "%)")

  sys.exit(0)

if __name__ == '__main__':
    main()
