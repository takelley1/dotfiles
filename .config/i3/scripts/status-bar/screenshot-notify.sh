#!/bin/bash

# status bar script to print to the status bar if a script called auto-screenshot.sh is NOT running

if [[ -z $(ps aux | grep "auto-screenshot\.sh$") ]]; then
    printf "%s\n" "Screenshot script not running!"
fi

exit 0
