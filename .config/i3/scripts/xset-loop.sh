#!/usr/bin/env dash
#
# Runs xset continuously, so added keyboards receive the correct configuration.
set -eu

while :; do
    xset r rate 190 50
    sleep 5s
done
