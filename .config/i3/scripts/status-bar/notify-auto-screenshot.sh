#!/bin/dash

# Status bar script to print a notification if auto-screenshot.sh is NOT running.

# Don't run on phobos.
[ "$(hostname)" = "phobos" ] && exit 0

[ -z "$(pgrep -f "/home/austin/scripts/bash/linux/auto-screenshot\.sh$")" ] && printf "%s\n" "Screenshot script not running!"

exit 0
