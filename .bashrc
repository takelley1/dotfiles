#
# Bash configuration file.
#

# ALIASES ########################################################################################## {{{

    # Git ------------------------------------------------------------------------------------------ {{{

    # Custom Git aliases for managing dotfiles.
    # See: https://developer.atlassian.com/blog/2016/02/best-way-to-store-dotfiles-git-bare-repo/
    alias dot='git --git-dir=$HOME/.cfg/ --work-tree=$HOME'

    alias d='dot'
    alias g='git'

    alias da='dot add'
    alias ga='git add'

    # Stage all changes below current path.
    alias daa='dot add --all ./'
    alias gaa='git add --all ./'

    # Stage all changes.
    alias daaa='dot add --all'
    alias gaaa='git add --all'

    # Add all modified files below current path.
    alias dau='dot add --update ./'
    alias gau='git add --update ./'

    # Add all modified files.
    alias dauu='dot add --update'
    alias gauu='git add --update'

    alias db='dot branch'
    alias gb='git branch'

    alias dc='dot commit'
    alias gc='git commit'

    alias dca='dot commit --all'
    alias gca='git commit --all'

    alias dcap='dot commit --all && dot push'
    alias gcap='git commit --all && git push'

    alias dcp='dot commit && dot push'
    alias gcp='git commit && git push'

    alias dcam='dot commit --all --message'
    alias gcam='git commit --all --message'

    alias dch='dot checkout'
    alias gch='git checkout'

    alias dcm='dot commit --message'
    alias gcm='git commit --message'

    alias dd='dot diff'
    alias gd='git diff'

    alias dds='dot diff --staged'
    alias gds='git diff --staged'

    alias dl='dot log --graph --oneline --full-history --abbrev-commit --all --color --decorate --pretty=format:"%x1b[31m%h%x09%x1b[32m%d%x1b[0m%x20%s"'
    alias gl='git log --graph --oneline --full-history --abbrev-commit --all --color --decorate --pretty=format:"%x1b[31m%h%x09%x1b[32m%d%x1b[0m%x20%s"'

    alias dm='dot merge'
    alias gm='git merge'

    alias dp='dot push'
    alias gp='git push'

    alias dpu='dot pull'
    alias gpu='git pull'

    alias dr='dot restore'
    alias gr='git restore'

    alias drm='dot rm'
    alias grm='git rm'

    alias drs='dot restore --staged'
    alias grs='git restore --staged'

    alias ds='dot status --untracked-files=no'
    alias dss='dot status'
    alias gs='git status'

    alias gsp='git submodule foreach git push'
    alias gsur='git submodule update --remote'

    # Show all tracked files.
    alias dt='dot ls-tree -r master --name-only'
    alias gt='git ls-tree -r master --name-only'

    function dcamp {
    dot commit --all --message "${@}" && dot push
    }
    function gcamp {
    git commit --all --message "${@}" && git push
    }

    function dcmp {
    dot commit --message "${@}" && dot push
    }
    function gcmp {
    git commit --message "${@}" && git push
    }

    # }}}
    # Utilities -------------------------------------------------------------------------------------{{{

    # Aliases for common utilities and apps.

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

    alias noproxy='export http_proxy=; export https_proxy=; export HTTP_PROXY=; export HTTPS_PROXY=; export npm_config_proxy='

    alias pip='pip --trusted-host pypi.org --trusted-host pypi.python.org --trusted-host files.pythonhosted.org'
    alias pip3='pip3 --trusted-host pypi.org --trusted-host pypi.python.org --trusted-host files.pythonhosted.org'
    alias pip3.8='pip3.8 --trusted-host pypi.org --trusted-host pypi.python.org --trusted-host files.pythonhosted.org'

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

    # }}}
    # Shortcuts -------------------------------------------------------------------------------------{{{

    # Aliases for easily accessing config files and directories.

    # Easy editing and committing of todo list.
    alias todo='cd ~/notes/ && git pull && ${EDITOR} ./personal--todo.md && git commit -m "Update todo.md" ./personal--todo.md && git push'

    alias fmt='fmt -w 120'

    alias alacrittyrc='${EDITOR} ~/.config/alacritty/alacritty.yml'
    alias banlist='${EDITOR} /mnt/share/documents/banlist.txt'
    alias bashrc='cd ~/.config/bashrc.d && ls'
    alias bashrcf='${EDITOR} ~/.bashrc'
    alias dunstrc='${EDITOR} ~/.config/dunst/dunstrc'

    alias readme='${EDITOR} ~/.github/README.md'
    alias tmuxrc='${EDITOR} ~/.config/tmux/tmux.conf'
    alias vimrc='${EDITOR} ~/.config/nvim/init.vim'
    alias plugins='cd ~/.local/share/nvim/site/pack/git-plugins/start/ && ls'
    alias xdefaults='${EDITOR} ~/.Xdefaults'
    alias xinitrc='${EDITOR} ~/.xinitrc'
    alias xprofile='${EDITOR} ~/.xprofile'

    alias i3b='${EDITOR} ~/.config/i3/i3blocks.conf'
    alias i3c='${EDITOR} ~/.config/i3/config-unique-${HOSTNAME}'
    alias i3cc='${EDITOR} ~/.config/i3/config-shared'
    alias i3ccc='${EDITOR} /tmp/.i3-config'

    alias config='cd ~/.config && ls'
    alias linux='cd ~/linux-notes && ls'
    alias notes='cd ~/notes/ && ls'
    alias roles='cd ~/scripts/ansible/roles && ls'
    alias scripts='cd ~/scripts/ && ls'

    # }}}
    # SSH -------------------------------------------------------------------------------------------{{{

    # Aliases for quickly SSHing into other hosts.

    alias europa='ssh 10.0.0.15'
    alias eris='ssh akelley@10.0.0.11'
    alias rhea='ssh root@10.0.0.4'

    # }}}

# }}}
# FREEBSD ########################################################################################## {{{

# FreeBSD-specific aliases and environment variables.

if [[ "${OSTYPE}" == "freebsd"* ]]; then

    export SHELL="/usr/local/bin/bash"
    export LANG="en_US.UTF-8"

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

# }}}
# LINUX ############################################################################################ {{{

# Linux-specific aliases and environment variables.
# shellcheck disable=2154

if [[ "${OSTYPE}" == "linux-gnu" ]]; then

    export SHELL="/bin/bash"

    # Add to $PATH
    if ! printf "%s\n" "${PATH}" | grep -q '/.local/bin'; then
        export PATH=${PATH}:~/.local/bin
    fi

    # asd.service breaks if this isn't enabled.
    xhost + &>/dev/null

    # This has been fixed.
    # # For some reason Ansible likes to add a bunch of junk at the end
    # #   of plays. Sed cleans this up.
    # ap() {
    #     ansible-playbook --diff "${@}" | sed '/^{/,$d'
    # }
    alias ap='ansible-playbook --diff'

    # Easily start/stop automounts.
    mnt() {
        # shellcheck disable=2046
        systemctl "${@}" \
        $(systemctl list-units \
            mnt*.*mount \
            --type=automount \
            --plain \
            --no-legend \
            --no-pager | \
            awk '{ORS=" "}; {print $1}') \
            2>/dev/null
    }

    alias l='ls --classify --color=auto --human-readable'
    alias ls='l'
    alias lr='l --reverse'
    alias lsr='lr'
    alias ll='l -l'
    alias la='l -l --all'
    alias lsal='l -l --all'
    alias lar='l -l --all --reverse'
    # Sort by size.
    alias lss='l -l --all -S'

    alias lcon='l -lZ --all --reverse'
    alias untar='tar -xzvf'

    if hash nvim 2>/dev/null; then
        export EDITOR="/usr/bin/nvim"
        export VISUAL="/usr/bin/nvim"
        export SUDO_EDITOR="/usr/bin/nvim"
    elif hash vim 2>/dev/null; then
        export EDITOR="/usr/bin/vim"
        export VISUAL="/usr/bin/vim"
        export SUDO_EDITOR="/usr/bin/vim"
    else
        export EDITOR="/usr/bin/vi"
        export VISUAL="/usr/bin/vi"
        export SUDO_EDITOR="/usr/bin/vi"
    fi

    # Use nvr to edit files within a single neovim instance on polaris.
    if [[ "${HOSTNAME}" == "polaris" ]]; then
        export EDITOR="/usr/bin/nvr -cc split --remote-wait"
        export VISUAL="/usr/bin/nvr -cc split --remote-wait"
        export SUDO_EDITOR="/usr/bin/vi"
    fi

fi

# }}}
# OPTIONS ########################################################################################## {{{

# Miscellaneous shell options and environment variables.

# Use vi-style editing for bash commands.
set -o vi
# Use jk to exit edit mode instead of ESC.
bind '"jk":vi-movement-mode'

if hash bat 2>/dev/null; then
    export BAT_THEME='TwoDark'
    alias cat='bat -p'
fi

export PAGER="less"
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

# }}}
# PROMPT ########################################################################################### {{{

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

# }}}
# FUNCTIONS ######################################################################################## {{{

# Miscellaneous bash functions.

# Automatically change the current working directory after closing ranger.
alias r='ranger_cd'
ranger_cd() {
    temp_file="$(mktemp -t "ranger_cd.XXXXXXXXXX")"
    ranger --choosedir="$temp_file" -- "${@:-$PWD}"
    if chosen_dir="$(cat -- "$temp_file")" && \
        [[ -n "$chosen_dir" ]] && \
        [[ "$chosen_dir" != "$PWD" ]]
    then
        cd -- "$chosen_dir" || exit 1
    fi
    rm -f -- "$temp_file"
}

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


# }}}
# STARTX ########################################################################################### {{{

# Start X without a display manager if logging into tty1 with a non-root account.
# shellcheck disable=2154

if [[ "${OSTYPE}" == "linux-gnu" ]]; then
    if [[ ! "${USER}" == "root" && -z "${DISPLAY}" && "$(tty)" == "/dev/tty1" ]]; then
        if hash startx 2>/dev/null; then
            exec startx
        fi
    fi
fi

# }}}
