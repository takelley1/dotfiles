#!/bin/bash

# Status bar script to print a notification if auto-screenshot.sh is NOT running.

# Don't run on phobos.
[[ ${HOSTNAME} == "phobos" ]] && exit 0

[[ -z $(ps aux | grep "auto-screenshot\.sh$") ]] && printf "%s\n" "Screenshot script not running!"

exit 0
