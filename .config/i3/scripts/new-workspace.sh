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
# shellcheck disable=2076
set -eu

# Print workspaces, remove quotes and formatting.
workspaces="$(i3-msg -t get_workspaces | jq '.[].name' | awk 'gsub(/[^0-9]/, "")')"

# Look for an available workspace number.
# This loop will create the lowest-numbered workspace that doesn't already exist.
for i in $(seq 1 30); do
    if [[ ! "${workspaces}" =~ "${i}" ]]; then
        workspace_to_create="${i}"
        # Break out of the loop as soon as an available workspace number is
        #   found.
        break 2
    fi
done

# Create and switch to the new workspace, or move window to new workspace.
if [[ "${1}" == "create" ]]; then
    i3-msg workspace "${workspace_to_create}" 1>/dev/null
elif [[ "${1}" == "move" ]]; then
    i3-msg "move container to workspace ${workspace_to_create}" 1>/dev/null
fi
