#!/usr/bin/env bash
#
# Sourced by bashrc.
#
# Configuration for main bash prompt.

if [[ "${USER}" == "root" ]]; then
    # Make username field of root prompts red.
    user_color=31
else
    user_color=32
fi

if [[ "${HOSTNAME}" != "polaris" ]] && [[ "${HOSTNAME}" != "tethys" ]]; then
    # Make hostname field of standard prompts yellow on servers.
    PS1="\[\033[01;${user_color}m\]\u\[\033[37m\]@\[\033[33m\]\h\[\033[37m\]:\[\033[01;34m\]\w\[\033[00m\]\$ "
else
    # Make standard prompts green on workstations.
    PS1="\[\033[01;${user_color}m\]\u\[\033[37m\]@\[\033[32m\]\h\[\033[37m\]:\[\033[01;34m\]\w\[\033[00m\]\$ "
fi
