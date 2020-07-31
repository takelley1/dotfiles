# ~/.bashrc. Executed by bash when launching interactive non-login shells.

####################################################################################################
# COMMON CONFIGURATION
####################################################################################################
# Configuration that is shared by both FreeBSD and Linux.

# STARTUP ==========================================================================================
tty="$(tty)"

# Start X without a display manager if logging into tty1 with a non-root account.
if [[ "${OSTYPE}" == "linux-gnu"
  && ! "${USER}" == "root"
  && -z "${DISPLAY}"
  && "${tty}" == "/dev/tty1" ]]; then
  exec startx
fi

# Reattach to the last tmux session or create a new one if it doesn't exist.
#   Requires "new-session -n $HOST" in ~/.tmux.conf file.
#   Only runs if tmux isn't already attached and if not tty2.
if [[ ! "${USER}" == "root"
  && -z "${TMUX}"
  && ! "${tty}" == "/dev/tty2" ]]; then
  exec tmux -f ~/.config/tmux/tmux.conf attach
fi

# Source bash alias scripts.
# shellcheck disable=1090
for file in ~/.config/bashrc.d/*.sh; do
  source "${file}"
done

# OPTIONS ==========================================================================================

# Use vi-style editing for bash commands.
set -o vi
# Use jk to exit edit mode instead of ESC.
bind '"jk":vi-movement-mode'

export TERM='screen-256color'
export PAGER='less'
export BROWSER='firefox'

# Add scripts to PATH
export PATH=$PATH:~/scripts/bash:~/scripts/bash/freebsd

# These vars are for the sxiv image viewer.
export XDG_CONFIG_HOME=~/.config
export XDG_CACHE_HOME=~/.cache

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

shopt -s histappend      # Append history rather than overwriting it.
shopt -q -s cmdhist      # Combine multiline commands into one in history.
shopt -q -s checkwinsize # Check window size after each command and update values of LINES and COLUMNS.
shopt -s cdspell         # Correct minor cd typos.

# RANGER ===========================================================================================

# Automatically change the current working directory after closing ranger
# This is a shell function to automatically change the current working
#   directory to the last visited one after ranger quits.

alias r='ranger_cd'
ranger_cd() {
    temp_file="$(mktemp -t "ranger_cd.XXXXXXXXXX")"
    ranger --choosedir="$temp_file" -- "${@:-$PWD}"
    if chosen_dir="$(cat -- "$temp_file")" && [[ -n "$chosen_dir" ]] && [[ "$chosen_dir" != "$PWD" ]]
    then
        cd -- "$chosen_dir" || exit 1
    fi
    rm -f -- "$temp_file"
}

# PROMPT ===========================================================================================

if [[ ${USER} == "root" ]]; then
    # Make root's prompt red to easily distinguish root from a standard user.
    PS1='\[\033[01;31m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    # Make standard users' prompts green.
    PS1='\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
fi

####################################################################################################
# FREEBSD CONFIGURATION
####################################################################################################

if [[ "${OSTYPE}" == "freebsd"* ]]; then
  export SHELL='/usr/local/bin/bash'
  export PATH=$PATH:~/scripts/bash/freebsd

  alias ls='ls -FCGh' # FreeBSD's ls uses a different syntax from Linux.
  alias ll='ls -l'
  alias la='ls -al'

  # Set proxy for FreeBSD here since there's no /etc/environment file.
  export http_proxy="http://10.0.0.15:8080"
  export https_proxy="http://10.0.0.15:8080"

  if [[ -x /usr/local/bin/nvim ]]; then
    export EDITOR='/usr/local/bin/nvim'
    export VISUAL='/usr/local/bin/nvim'
    export SUDO_EDITOR='/usr/local/bin/nvim'
  elif [[ -x /usr/local/bin/vim ]]; then
    export EDITOR='/usr/local/bin/vim'
    export VISUAL='/usr/local/bin/vim'
    export SUDO_EDITOR='/usr/local/bin/vim'
  else
    export EDITOR='/usr/local/bin/vi'
    export VISUAL='/usr/local/bin/vi'
    export SUDO_EDITOR='/usr/local/bin/vi'
  fi

####################################################################################################
# LINUX CONFIGURATION
####################################################################################################

elif [[ "${OSTYPE}" == "linux-gnu" ]]; then
  export SHELL='/bin/bash'
  export PATH=$PATH:~/scripts/bash/linux

  alias ls='ls --classify --color=auto --human-readable'
  alias l='ls'
  alias lr='ls --classify --color=auto --human-readable --reverse'
  alias lsr='lr'

  alias ll='ls --classify --color=auto --human-readable -l'           # Show single-column.
  alias llr='ls --classify --color=auto --human-readable -l --reverse'
  alias la='ls --classify --color=auto --human-readable -l --all'
  alias lar='ls --classify --color=auto --human-readable -l --all --reverse'
  alias lss='ls --classify --color=auto --human-readable -l --all -S' # Sort by size.

  alias lcon='ls -lZ --all --reverse'
  alias untar='tar -xzvf'

  if [[ -x /usr/bin/nvim ]]; then
    export EDITOR='/usr/bin/nvim'
    export VISUAL='/usr/bin/nvim'
    export SUDO_EDITOR='/usr/bin/nvim'
  elif [[ -x /usr/bin/vim ]]; then
    export EDITOR='/usr/bin/vim'
    export VISUAL='/usr/bin/vim'
    export SUDO_EDITOR='/usr/bin/vim'
  else
    export EDITOR='/usr/bin/vi'
    export VISUAL='/usr/bin/vi'
    export SUDO_EDITOR='/usr/bin/vi'
  fi
fi
