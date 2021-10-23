#!/usr/bin/env dash
#
# Restarts i3 in-place.
# This helper script is necessary since the i3 config file must be built from
#   multiple parts. See ~/.xinitrc
#
set -eu

# Ensure i3 running config file is empty.
true >/tmp/.i3-config

# Build i3 config file out of a shared common configuration and a
#   separate configuration unique to the current host.
cat "${HOME}/.config/i3/.config-notification" \
    "${HOME}/.config/i3/config-unique-$(hostname)" \
    "${HOME}/.config/i3/config-shared" \
    >/tmp/.i3-config

i3-msg restart 1>/dev/null
