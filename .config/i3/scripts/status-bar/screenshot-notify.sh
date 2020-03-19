#!/bin/bash

# Status bar script to print a notification if auto-screenshot.sh is NOT running.

# Don't run on phobos.
if [[ ${HOSTNAME} == "phobos" ]]; then
    exit 0

elif [[ -z $(ps aux | grep "auto-screenshot\.sh$") ]]; then
    printf "%s\n" "Screenshot script not running!"
fi

exit 0
