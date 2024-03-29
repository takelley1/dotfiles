# FREEBSD ##################################################################################### {{{

# FreeBSD-specific aliases and environment variables.

if [[ "${OSTYPE}" =~ "bsd" ]]; then

    export SHELL="/usr/local/bin/bash"

    # FreeBSD's ls uses a different syntax from Linux.
    alias ls='ls -FCGh'
    alias ll='ls -l'
    alias la='ls -al'

    # Set proxy for FreeBSD here since there's no /etc/environment file.
    export http_proxy="http://10.0.0.15:8080"
    export https_proxy="http://10.0.0.15:8080"

fi

# }}}
# LINUX ####################################################################################### {{{

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

    # asd.service breaks if this isn't enabled.
    xhost + &>/dev/null

    alias ls='ls --classify --color=auto --human-readable'
    alias lr='l --reverses --classify --color=auto --human-readable'
    alias lsr='l -l --reverses --classify --color=auto --human-readable'
    alias ll='ls -ls --classify --color=auto --human-readable'
    alias la='ls -l --all --classify --color=auto --human-readable'
    alias lsal='l -l --all --classify --color=auto --human-readable'
    alias lar='l -l --all --reverses --classify --color=auto --human-readable'

    alias dmesg='dmesg --human --ctime --decode'

    # Use nvr to edit files within a single neovim instance on polaris.
    if [[ "${HOSTNAME}" == "polaris" ]]; then
        export EDITOR="/usr/bin/nvr -cc split --remote-wait"
        export VISUAL="/usr/bin/nvr -cc split --remote-wait"
        export SUDO_EDITOR="/usr/bin/vi"
        source "/etc/profile.d/proxy.sh"
    fi

    alias i3-reboot='i3-save && i3-resurrect ls && sleep 10 && reboot'
    alias i3-shutdown='i3-save && shutdown now'
    alias restore='i3-restore'
    alias i3-ls='i3-resurrect ls'

    i3-save() {
        echo "Saving workspaces ..."
        i3-msg -t get_workspaces |
            jq -r '.[].name' |
            awk '{print "\"" $0 "\""}' |
            xargs -P 0 -n 1 -- i3-resurrect save -w
    }
    i3-rm() {
        echo "Removing workspaces ..."
        i3-resurrect ls |
            awk '{gsub(/^Workspace\s+|\s+(layout|programs)$/, ""); print "\"" $0 "\""}' |
            sort -u |
            xargs -P 0 -n 1 -- i3-resurrect rm -w
    }
    # Don't use xargs -P here since it will cause all workspaces to restore to
    #   the same window.
    i3-restore() {
        echo "Restoring workspaces ..."
        i3-resurrect ls |
            awk '{gsub(/^Workspace\s+|\s+(layout|programs)$/, ""); print "\"" $0 "\""}' |
            sort -u |
            xargs -n 1 -- i3-resurrect restore -w
    }

    # Uses my mdd.service to generate a list of files for fzf to search through.
    # Selects a file from the mlocate database using fzf, then open the filepath in ranger.
    f() {
        file="$(fzf --color=light --no-hscroll --keep-right --no-mouse <~/.locatedb)"
        cd "$(dirname "${file}")" || exit 1
        [[ -n "${file}" ]] && ranger --selectfile="${file}"
    }

    # if this is interactive shell, then bind hstr to Ctrl-r.
    # Used by hstr https://github.com/dvorka/hstr
    export HSTR_CONFIG=monochromatic,prompt-bottom,help-on-opposite-side
    export PROMPT_COMMAND="history -a; history -n; ${PROMPT_COMMAND}"
    if [[ $- =~ .*i.* ]]; then
        set -o vi # The below binding only takes effect if vi mode is enabled.
        bind '"\C-r": "\e^ihstr -- \n"'
    fi
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

alias dl='lazygit -g $HOME/.cfg/ -w $HOME'

alias dL='dot log --graph --oneline --full-history --abbrev-commit --all --color --decorate --pretty=format:"%x1b[31m%h%x09%x1b[32m%d%x1b[0m%x20%s"'
alias gL='git log --graph --oneline --full-history --abbrev-commit --all --color --decorate --pretty=format:"%x1b[31m%h%x09%x1b[32m%d%x1b[0m%x20%s"'

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
# Utilities --------------------------------------------------------------------------------{{{

# Aliases for common utilities and apps.
alias mv='mv -v'
alias cp='cp -v'
alias sudo='sudo '     # This is required for bash aliases to work with sudo.
alias less='less -XRF' # Show text in terminal even after quitting less.
alias grep='grep --color=always'
alias mkdir='mkdir -pv' # Always make parent directories.

# Use mosh if possible - https://mosh.org/
ssh() {
    if ! hash 2>/dev/null mosh; then
        echo "Mosh on the client is missing! Using ssh instead."
        command ssh "${@}"
        return 1
    fi

    # -a = Always use prediction.
    mosh -a "${@}"

    if [[ "$(echo $?)" -eq 10 ]]; then
        echo "Mosh on server is missing! Using ssh instead."
        command ssh "${@}"
    fi
}

ap() {
    ansible-playbook --diff "${@}"
}

alias bc='bc -l'
alias rss='newsboat'
alias tmux='tmux -f ~/.config/tmux/tmux.conf'
alias tokei='tokei -n commas'

# Easily enable or disable proxy config.
noproxy() {
    export http_proxy=
    export https_proxy=
    export HTTP_PROXY=
    export HTTPS_PROXY=
    export npm_config_proxy=
}

proxy() {
    export http_proxy="http://10.0.0.15:8080"
    export https_proxy="${http_proxy}"
    export HTTP_PROXY="${http_proxy}"
    export HTTPS_PROXY="${http_proxy}"
    export npm_config_proxy="${http_proxy}"
}

alias reset='pokoy && pokoy -k && pokoy -r && pokoy' # Reset break timer.

alias pip='pip --trusted-host pypi.org --trusted-host pypi.python.org --trusted-host files.pythonhosted.org'
alias pip3='pip3 --trusted-host pypi.org --trusted-host pypi.python.org --trusted-host files.pythonhosted.org'
alias pip3.8='pip3.8 --trusted-host pypi.org --trusted-host pypi.python.org --trusted-host files.pythonhosted.org'

alias define='dict'
alias eve='bash /opt/evesetup/lib/evelauncher/evelauncher.sh &'
alias audible='bash /opt/OpenAudible/OpenAudible &'
# On neovim terminals, the cursor disappears after newsboat exits. This forces the cursor
#   to reappear.
alias newsboat='newsboat && echo -en "\e[?25h"'
alias feh='feh --draw-tinted --draw-filename --keep-zoom-vp --force-aliasing --fullscreen'

alias snip='bash ~/.config/i3/scripts/screenshot-region.sh'

# }}}
# Navigation shortcuts ---------------------------------------------------------------------{{{

# Easy editing and committing of todo list.
alias todo='cd ~/notes/ && git pull && ${EDITOR} ./personal--todo.md && git commit
                -m "Update todo.md" ./personal--todo.md && git push'

alias fmt='fmt -w 120'

cd() {
    command cd "${@}"
    ls
}

mediainfo() {
    command mediainfo "${@}" | less
}

alias h='cd ~'
alias u='cd ../' # "Up 1 directory."

alias a='cd ~/scripts/ansible'
alias b='cd ~/scripts/bash'
# `c` is already used for `clear`.
alias d='cd ~/Downloads'
alias D='cd ~/Documents'
alias e='cd ~/scripts/ansible/roles/ansible-role-e2guardian'
alias i='cd ~/.config/i3'
alias l='cd ~/library'
alias n='cd ~/notes'
alias o='cd ~/.config'
alias p='cd ~/.local/share/nvim/plugged'
alias P='cd ~/Pictures'
alias roles='cd ~/scripts/ansible/roles' # `r` is already used to call Ranger.
alias s='cd ~/.config/i3/scripts/status-bar'
alias v='cd ~/videos'
alias x='cd ~/linux-notes' # `x` for `*nix.`
alias y='cd ~/videos/youtube'

alias i3b='${EDITOR} ~/.config/i3/i3blocks.conf'
alias i3c='${EDITOR} ~/.config/i3/config-unique-${HOSTNAME}'
alias i3cc='${EDITOR} ~/.config/i3/config-shared'
alias i3ccc='${EDITOR} /tmp/.i3-config'

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

# Show the current branch.
# See https://www.shellhacks.com/show-git-branch-terminal-command-prompt/
git_branch() {
    git branch 2>/dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/'
}
git_branch_color="\[\033[35m\]"

# Show if any unstaged changes have been made on the current branch and if any
#   commits need to be pushed/pulled from remote.
git_status() {
    if [[ -n "$(git_branch)" ]]; then
        git status --short --branch 2>/dev/null |
            awk -F'[][]' \
                '{
            # Operate on 1st line only.
            if(NR==1)
                {
                # Replace ahead/behind with arrows.
                sub(/ahead/,"▲")
                sub(/behind/,"▼")

                # Remove comma and spaces.
                gsub(/(\s|,)/,"")

                # Store in a variable.
                ahead_behind_count=$2
                }
            # If theres more than 1 line, then the repo has unstaged changes.
            if(NR>1)
                changed="(+)"
            }
            # Use END so we only print once and not once for every record.
            # Use printf instead of print so fields are not separated by spaces.
            END {printf "%s%s",ahead_behind_count,changed}
            '
    fi
}
git_status_color="\[\033[36m\]"

# See https://stackoverflow.com/questions/4133904/ps1-line-with-git-current-branch-and-colors
user_and_host="\[\033[01;${user_color}m\]\u@\h"
current_dir="\[\033[01;34m\]\w"
colon_separator="\[\033[00m\]:"
text_color="\[\033[00m\]"

# Running git_status can take a while on git repos on NFS mounts.
# PS1="${user_and_host}${colon_separator}${current_dir}${git_branch_color}\$(git_branch)${git_status_color}\$(git_status)${text_color}\$ "
PS1="${user_and_host}${colon_separator}${current_dir}${git_branch_color}\$(git_branch)${text_color}\$ "

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

# Same as ranger_cd(), but for lf
# https://github.com/gokcehan/lf/blob/master/etc/lfcd.sh
alias c='lfcd'
lfcd() {
    temp_file="$(mktemp -t "lf_cd.XXXXXXXXXX")"
    lf -last-dir-path="$temp_file" -- "$@"
    if [ -f "$temp_file" ]; then
        dir="$(cat "$temp_file")"
        rm -f "$temp_file"
        if [ -d "$dir" ]; then
            if [ "$dir" != "$(pwd)" ]; then
                cd "$dir" || exit 1
            fi
        fi
    fi
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

# }}}
# STARTX ###################################################################################### {{{

# Start X without a display manager if logging into tty1 with a non-root account.
# shellcheck disable=2154

[[ ! "${USER}" == "root" ]] &&
    [[ -n "${PS1}" ]] &&
    [[ -z "${DISPLAY}" ]] &&
    [[ "$(tty)" == "/dev/tty1" ]] &&
    hash startx 2>/dev/null &&
    exec startx

# }}}
