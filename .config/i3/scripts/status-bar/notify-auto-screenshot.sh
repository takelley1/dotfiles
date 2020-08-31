#!/usr/bin/env dash
#
# Status bar script to print a notification if asd.sh isn't running.

if [ -z "$(pgrep -f "${HOME}/scripts/bash/linux/systemd/asd\.sh$")" ]; then
    printf "%s\n" "Screenshot script not running!"
fi

exit 0
