#!/usr/bin/env bash
#
# Sourced by bashrc.
#
# Aliases for common utilities and apps.

# UTILITIES -------------------------------------------------------------------

# Make nvim follow symlinks.
# This makes it easier to use Git mappings within nvim.
# From: https://stackoverflow.com/questions/30791692/make-vim-follow-symlinks-when-opening-files-from-command-line
function nvim {
    args=()
    for i in "$@"; do
        if [[ -h $i ]]; then
            args+=("$( readlink "$i" )")
        else
            args+=("$i")
        fi
    done
    /usr/bin/nvim -p "${args[@]}"
}

# "Up 1 directory."
alias u='cd ../'

alias h='cd ~'
alias c='clear'

alias mv='mv -v'
alias cp='cp -v'

alias sudo='sudo ' # This is required for bash aliases to work with sudo.

alias less='less -XRF' # Show text in terminal even after quitting less.
alias grep='grep --color=always'
alias mkdir='mkdir -pv' # Always make parent directories.

# PROXIES ---------------------------------------------------------------------

alias noproxy='export http_proxy=; export https_proxy=; export HTTP_PROXY=; export HTTPS_PROXY=; export npm_config_proxy='

alias pip='pip --trusted-host pypi.org --trusted-host pypi.python.org --trusted-host files.pythonhosted.org'
alias pip3='pip3 --trusted-host pypi.org --trusted-host pypi.python.org --trusted-host files.pythonhosted.org'
alias pip3.8='pip3.8 --trusted-host pypi.org --trusted-host pypi.python.org --trusted-host files.pythonhosted.org'

# APPS ------------------------------------------------------------------------

# Reset break timer.
alias reset='pokoy && pokoy -k && pokoy -r && pokoy'

alias ta='tmux -f ~/.config/tmux/tmux.conf attach'
alias tmux='tmux -f ~/.config/tmux/tmux.conf'

alias define='dict'
alias eve='bash /opt/evesetup/lib/evelauncher/evelauncher.sh &'
alias audible='bash /opt/OpenAudible/OpenAudible &'

alias osrs='bash ~/scripts/bash/linux/osrs.sh &'
alias runescape='osrs'
alias rs='osrs'
alias snip='scrot --quality 100 --select --freeze --silent'
alias s='bash ~/scripts/bash/linux/ocvbot-sync-manual.sh'
