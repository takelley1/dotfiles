#!/usr/bin/env bash
#
# Sourced by bashrc.
#
# Configuration for main bash prompt.

if [[ ${USER} == "root" ]]; then
    # Make root's prompt red to easily distinguish root from a standard user.
    PS1='\[\033[01;31m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    # Make standard users' prompts green.
    PS1='\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
fi
