#!/usr/bin/env bash
#
# Sourced by bashrc.
#
# Configuration for main bash prompt.

if [[ "${USER}" == "root" ]]; then
    # Make root prompts red.
    PS1='\[\033[01;31m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    if [[ "${HOSTNAME}" != "polaris" ]] && [[ "${HOSTNAME}" != "tethys" ]]; then
        # Make standard user prompts yellow on servers.
        PS1='\[\033[01;33m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
    else
        # Make standard user prompts green on workstations.
        PS1='\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
    fi
fi
