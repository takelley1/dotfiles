#!/usr/bin/env bash

# shellcheck disable=2076
# Linux-specific aliases and environment variables.
# shellcheck disable=2154

if [[ "${OSTYPE}" =~ "linux" ]]; then

    export SHELL="/bin/bash"

    # Add paths to $PATH. Prevent them from getting added multiple times.
    [[ ":${PATH}:" =~ "${HOME}/.local/bin" ]] || PATH="${PATH}:${HOME}/.local/bin"
    [[ ":${PATH}:" =~ "${HOME}/scripts/bash" ]] || PATH="${PATH}:${HOME}/scripts/bash"
    [[ ":${PATH}:" =~ "${HOME}/scripts/bash/linux" ]] || PATH="${PATH}:${HOME}/scripts/bash/linux"
    [[ ":${PATH}:" =~ "${HOME}/scripts/bash/linux/shell-functions" ]] || PATH="${PATH}:${HOME}/scripts/bash/linux/shell-functions"

    alias ls='ls --classify --color=auto --human-readable'
    alias lr='l --reverses --classify --color=auto --human-readable'
    alias lsr='l -l --reverses --classify --color=auto --human-readable'
    alias ll='ls -ls --classify --color=auto --human-readable'
    alias la='ls -l --all --classify --color=auto --human-readable'
    alias lsal='l -l --all --classify --color=auto --human-readable'
    alias lar='l -l --all --reverses --classify --color=auto --human-readable'

    alias dmesg='dmesg --human --ctime --decode'

    # Uses my mdd.service to generate a list of files for fzf to search through.
    # Selects a file from the mlocate database using fzf, then open the filepath in ranger.
    f() {
        file="$(fzf --color=light --no-hscroll --keep-right --no-mouse <~/.locatedb)"
        cd "$(dirname "${file}")" || exit 1
        [[ -n "${file}" ]] && ranger --selectfile="${file}"
    }

    # Configure Autojump
    # https://github.com/wting/autojump
    if [[ -f /usr/share/autojump/autojump.bash ]]; then
        source /usr/share/autojump/autojump.bash
    fi
fi

# }}}
# ALIASES ##################################################################################### {{{

# Git ------------------------------------------------------------------------------------- {{{

# Custom Git aliases for managing dotfiles.
# See: https://developer.atlassian.com/blog/2016/02/best-way-to-store-dotfiles-git-bare-repo/
alias dot='git --git-dir=$HOME/.cfg/ --work-tree=$HOME'

alias d='dot'
alias g='git'

alias dl='lazygit -g $HOME/.cfg/ -w $HOME'

alias dL='dot log --graph --oneline --full-history --abbrev-commit --all --color --decorate --pretty=format:"%x1b[31m%h%x09%x1b[32m%d%x1b[0m%x20%s"'
alias gL='git log --graph --oneline --full-history --abbrev-commit --all --color --decorate --pretty=format:"%x1b[31m%h%x09%x1b[32m%d%x1b[0m%x20%s"'

alias drs='dot restore --staged'
alias grs='git restore --staged'

alias ds='dot status --untracked-files=no'

# Show all tracked files.
alias dt='dot ls-tree -r master --name-only'
alias gt='git ls-tree -r master --name-only'

# }}}
# Utilities --------------------------------------------------------------------------------{{{

# Aliases for common utilities and apps.
alias mv='mv -v'
alias cp='cp -v'
alias sudo='sudo '     # This is required for bash aliases to work with sudo.
alias less='less -XRF' # Show text in terminal even after quitting less.
alias grep='grep --color=always'
alias mkdir='mkdir -pv' # Always make parent directories.

ap() {
    ansible-playbook --diff "${@}"
}

alias bc='bc -l'
alias tmux='tmux -f ~/.config/tmux/tmux.conf'
alias tokei='tokei -n commas'

alias pip='pip --trusted-host pypi.org --trusted-host pypi.python.org --trusted-host files.pythonhosted.org'
alias pip3='pip3 --trusted-host pypi.org --trusted-host pypi.python.org --trusted-host files.pythonhosted.org'
alias pip3.8='pip3.8 --trusted-host pypi.org --trusted-host pypi.python.org --trusted-host files.pythonhosted.org'

# }}}
# Navigation shortcuts ---------------------------------------------------------------------{{{

cd() {
    command cd "${@}"
    ls
}

alias h='cd ~'
alias u='cd ../' # "Up 1 directory."

# }}}

# }}}
# OPTIONS ##################################################################################### {{{

# Miscellaneous shell options and environment variables.

# Use vi-style editing for bash commands.
set -o vi
# Use jk to exit edit mode instead of ESC.
bind '"jk":vi-movement-mode'

# These 3 bindings mimic zsh-style TAB-completion.
bind '"\t":menu-complete'           # Cycle through matching files.
bind "set show-all-if-ambiguous on" # Display a list of the matching files.
# Perform partial (common) completion on the first Tab press, only start
# cycling full results on the second Tab press (from bash version 5)
bind "set menu-complete-display-prefix on"

if hash bat 2>/dev/null; then
    export BAT_THEME='TwoDark'
    #alias cat='bat -p'
fi

if hash nvim 2>/dev/null; then
    export EDITOR="nvim"
elif hash vim 2>/dev/null; then
    export EDITOR="vim"
else
    export EDITOR="vi"
fi
export VISUAL="${EDITOR}"
export SUDO_EDITOR="${EDITOR}"

export GIT_SSL_NO_VERIFY="true"
export PAGER="less -XRFS"
export TERM="screen-256color"
export BROWSER="firefox"

# These vars are for the sxiv image viewer.
export XDG_CONFIG_HOME="${HOME}/.config"
export XDG_CACHE_HOME="${HOME}/.cache"

# Force colored manpages.
export LESS_TERMCAP_mb=$'\E[01;31m'
export LESS_TERMCAP_md=$'\E[01;31m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[01;32m'
# Fix prompt colors.
export LESS_TERMCAP_so=$'\E[1;102m\E[1;30m'

# History modifications.
export HISTIGNORE="&:ls:[bf]g:exit"
export HISTFILESIZE=9999999
export HISTSIZE=9999999
export HISTCONTROL=ignoreboth
# https://github.com/wting/autojump
export PROMPT_COMMAND="${PROMPT_COMMAND:+$PROMPT_COMMAND ;} history -a"

# Allow unicode within the terminal.
export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"

# Allow recursive globbing.
shopt -s globstar

# Append history rather than overwriting it.
shopt -s histappend

# Combine multiline commands into one in history.
shopt -q -s cmdhist

# Check window size after each command and update values of LINES and COLUMNS.
shopt -q -s checkwinsize

# Correct minor cd typos.
shopt -s cdspell

# }}}
# PROMPT ###################################################################################### {{{

# Configuration for main bash prompt.

# COLORS:
# Black  30
# Red    31
# Green  32
# Yellow 33
# Blue   34
# Purple 35
# Cyan   36
# White  37

if [[ "${USER}" == "root" ]]; then
    # Make username field of root prompts red.
    user_color=31
else
    user_color=32
fi

# }}}
# FUNCTIONS ################################################################################### {{{

# Miscellaneous bash functions.

# Automatically change the current working directory after closing ranger.
alias r='ranger_cd'
ranger_cd() {
    temp_file="$(mktemp -t "ranger_cd.XXXXXXXXXX")"
    ranger --choosedir="$temp_file" -- "${@:-$PWD}"
    if chosen_dir="$(cat -- "$temp_file")" &&
        [[ -n "$chosen_dir" ]] &&
        [[ "$chosen_dir" != "$PWD" ]]; then
        cd -- "$chosen_dir" || exit 1
    fi
    rm -f -- "$temp_file"
}

# Make nvim follow symlinks. This makes it easier to use Git mappings within nvim.
# From: https://stackoverflow.com/questions/30791692/make-vim-follow-symlinks-when-opening-files-from-command-line
nvim() {
    args=()
    for i in "$@"; do
        if [[ -L $i ]]; then
            args+=("$(readlink "$i")")
        else
            args+=("$i")
        fi
    done
    /usr/bin/nvim -p "${args[@]}"
}