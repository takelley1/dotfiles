#!/usr/bin/env dash
#
# Status bar script to print a notification if auto-screenshot.sh is NOT running.

if [ -z "$(pgrep -f "${HOME}/scripts/bash/linux/systemd/auto-screenshot\.sh$")" ]; then
    printf "%s\n" "Screenshot script not running!"
fi

exit 0
