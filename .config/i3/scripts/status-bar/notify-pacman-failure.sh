#!/usr/bin/env dash
#
# Status bar script that notifies the user if the daily pacman update job
#   has failed.

journalctl \
    --output=cat \
    --since=today \
    --grep="error: failed to commit transaction" \
    --unit=aud

exit 0
