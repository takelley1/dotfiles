#!/usr/bin/env bash
#
# Creates a new workspace on the current display.
#
# "${1}" is used to either switch to the new workspace or move the current
#   window to the new workspace.
#
# USAGE:
#   `new-workspace.sh move` = Move the current window to a new workspace on
#                              the current display.
#   `new-workspace.sh create` = Create a new workspace on the current display
#                                 and switch to it.
set -eu

# Print workspaces, remove quotes and formatting, then sort and print the highest-numbered workspace.
highest_workspace="$(i3-msg -t get_workspaces | jq '.[].name' | awk 'gsub(/[^0-9]/, "")' | sort --numeric | tail -1)"

# Add 1 to determine the new workspace's number.
new_workspace=$((highest_workspace + 1))

# Create and switch to the new workspace, or move window to new workspace.
if [[ "${1}" == "create" ]]; then
    i3-msg workspace "${new_workspace}" 1>/dev/null
elif [[ "${1}" == "move" ]]; then
    i3-msg "move container to workspace ${new_workspace}" 1>/dev/null
fi
