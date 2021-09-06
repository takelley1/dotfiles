#!/usr/bin/env dash
#
# Status bar script to print a notification if the automatic-screenshot-daemon
#   isn't running.

if ! systemctl is-active asd.service --quiet; then
    printf "%s\n" "Screenshot script not running!"
fi

exit 0
