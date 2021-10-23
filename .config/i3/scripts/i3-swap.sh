#!/usr/bin/env bash
#
# Quickly swaps a window with its counterpart on another display.
# Only works if one window is on each display's workspace.
#
# Focus is kept on the main display.
#
# Assumes displays are oriented such that the secondary display is located to
#   the left of the main display.
set -eu

if [[ "${1}" == "left" ]]; then
    i3-msg "move left"  # Move workpsace to the left display.
    i3-msg "focus left" # Focus workspace that was on the left display.
    i3-msg "move right" # Move that workspace to the center display.
    i3-msg "move right"
elif [[ "${1}" == "right" ]]; then
    i3-msg "move right"  # Move workspace to the center display.
    i3-msg "focus right" # Focus workspace that was on the center display.
    i3-msg "move left"   # Move that workspace to the left display.
    i3-msg "move left"
    i3-msg "focus right" # Return focus to the center display.
fi
