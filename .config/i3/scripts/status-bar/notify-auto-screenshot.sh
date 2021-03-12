#!/usr/bin/env dash
#
# Status bar script to print a notification if the automatic-screenshot-daemon
#   isn't running.

if [ -z "$(pgrep -f "${HOME}/.*asd\.sh$")" ]; then
    printf "%s\n" "Screenshot script not running!"
fi
