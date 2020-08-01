# Sourced by bashrc.
#
# Miscellaneous shell options and environment variables.

# Use vi-style editing for bash commands.
set -o vi
# Use jk to exit edit mode instead of ESC.
bind '"jk":vi-movement-mode'

export TERM="screen-256color"
export PAGER="less"
export BROWSER="firefox"

# These vars are for the sxiv image viewer.
export XDG_CONFIG_HOME="${HOME}/.config"
export XDG_CACHE_HOME="${HOME}/.cache"

# Force colored manpages.
export LESS_TERMCAP_mb=$'\E[01;31m'
export LESS_TERMCAP_md=$'\E[01;31m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[01;44;33m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[01;32m'

# History modifications.
export HISTIGNORE="&:ls:[bf]g:exit"
export HISTFILESIZE=9999999
export HISTSIZE=9999999
export HISTCONTROL=ignoreboth
export PROMPT_COMMAND='history -a'

# Append history rather than overwriting it.
shopt -s histappend

# Combine multiline commands into one in history.
shopt -q -s cmdhist

# Check window size after each command and update values of LINES and COLUMNS.
shopt -q -s checkwinsize

# Correct minor cd typos.
shopt -s cdspell
