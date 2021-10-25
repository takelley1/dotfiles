#!/usr/bin/env bash
# Swap i3 windows with other windows on other displays.
# Ensure focus is kept on the main display in the center (DisplayPort-3).
set -eu

# Get the output for the current workspace
workspace_output="$(i3-msg -t get_workspaces | jq '.[] | select(.focused == true) | .output')"

if [[ "${1}" == "left" ]]; then
    i3-msg "move left"  # Move window on current display to other display.
    i3-msg "focus left" # Focus window on other display.
    i3-msg "move right" # Move that window to the other side of that display.
    i3-msg "move right" # Move that window to the current display.
    if [[ ! "${workspace_output}" =~ "DisplayPort-3" ]]; then
        i3-msg "focus left"  # Return focus to the main display.
    fi

elif [[ "${1}" == "right" ]]; then
    i3-msg "move right"
    i3-msg "focus right"
    i3-msg "move left"
    i3-msg "move left"
    if [[ ! "${workspace_output}" =~ "DisplayPort-3" ]]; then
        i3-msg "focus right"
    fi
fi
