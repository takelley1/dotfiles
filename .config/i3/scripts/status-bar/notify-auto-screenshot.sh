#!/usr/bin/env dash
#
# Status bar script to print a notification if auto-screenshot.sh is NOT running.

# Don't run on phobos.
if [ "$(hostname)" = "phobos" ]; then
  exit 0
fi

if [ -z "$(pgrep -f "/home/austin/scripts/bash/linux/systemd/auto-screenshot\.sh$")" ]; then
  printf "%s\n" "Screenshot script not running!"
fi

exit 0
