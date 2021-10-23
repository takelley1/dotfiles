#!/usr/bin/env dash
#
# Creates a new workspace on the current display.
set -eu

# Print workspaces, remove quotes and formatting, then sort and print the highest-numbered workspace.
highest_workspace="$(i3-msg -t get_workspaces | jq '.[].name' | awk 'gsub(/[^0-9]/, "")' | sort --numeric | tail -1)"

# Add 1 to determine the new workspace's number.
new_workspace=$((highest_workspace + 1))

# Create and switch to the new workspace.
i3-msg workspace "${new_workspace}" 1>/dev/null
