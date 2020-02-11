# ~/.profile, sourced when launching interactive login shells
# place stuff here that applies to the whole user session

export LC_CTYPE=en_US.UTF-8

export PAGER='less'
export EDITOR='nvim'
export BROWSER='firefox'

# add main bash scripting dir to path
export PATH="$PATH:/home/austin/scripts/bash"

# vars for sxiv image viewer
export XDG_CONFIG_HOME=~/.config
export XDG_CACHE_HOME=~/.cache

# colored manpages
export LESS_TERMCAP_mb=$'\E[01;31m'
export LESS_TERMCAP_md=$'\E[01;31m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[01;44;33m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[01;32m'

# history modifications
export HISTIGNORE="&:ls:[bf]g:exit"
export HISTFILESIZE=9999999
export HISTSIZE=9999999
# ignore duplicates, 'ls' without options, and builtin commands
export HISTCONTROL=ignoredups
export HISTCONTROL=ignoreboth
# append history instead of overwriting it
export PROMPT_COMMAND='history -a'
# combine multiline commands into one in history
shopt -s cmdhist
# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize
