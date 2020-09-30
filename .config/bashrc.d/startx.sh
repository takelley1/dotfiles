#!/usr/bin/env bash
#
# Sourced by bashrc.
#
# Start X without a display manager if logging into tty1 with a non-root account.
#
# shellcheck disable=2154

if [[ "${OSTYPE}" == "linux-gnu" && ! "${USER}" == "root" && -z "${DISPLAY}" && "${tty}" == "/dev/tty1" ]]; then
    if hash startx 2>/dev/null; then
        exec startx
    fi
fi
