#!/usr/bin/env bash
#
# Sourced by bashrc.
#
# FreeBSD-specific aliases and environment variables.

if [[ "${OSTYPE}" == "freebsd"* ]]; then

    export SHELL="/usr/local/bin/bash"

    # FreeBSD's ls uses a different syntax from Linux.
    alias ls='ls -FCGh'
    alias ll='ls -l'
    alias la='ls -al'

    # Set proxy for FreeBSD here since there's no /etc/environment file.
    export http_proxy="http://10.0.0.15:8080"
    export https_proxy="http://10.0.0.15:8080"

    if hash nvim 2>/dev/null; then
        export EDITOR="/usr/local/bin/nvim"
        export VISUAL="/usr/local/bin/nvim"
        export SUDO_EDITOR="/usr/local/bin/nvim"
    elif hash vim 2>/dev/null; then
        export EDITOR="/usr/local/bin/vim"
        export VISUAL="/usr/local/bin/vim"
        export SUDO_EDITOR="/usr/local/bin/vim"
    else
        export EDITOR="/usr/local/bin/vi"
        export VISUAL="/usr/local/bin/vi"
        export SUDO_EDITOR="/usr/local/bin/vi"
    fi
fi
