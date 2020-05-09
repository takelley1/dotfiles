# ~/.bashrc. Executed by bash when launching interactive non-login shells.

# STARTUP #################################################################################

# Start X without a display manager if logging into tty1 with a non-root account.
[[ ! ${USER} == "root" ]] && [[ -z ${DISPLAY} ]] && [[ $(tty) == "/dev/tty1" ]] && exec startx

# Reattach to the last tmux session or create a new one if it doesn't exist.
#   Requires "new-session -n $HOST" in ~/.tmux.conf file.
#   Only runs if tmux isn't already attached.
[[ ! ${USER} == "root" ]] && [[ -z ${TMUX} ]] && exec tmux -f ~/.config/tmux/tmux.conf attach

# ALIASES #################################################################################

alias ta='tmux -f ~/.config/tmux/tmux.conf attach'
alias tmux='tmux -f ~/.config/tmux/tmux.conf'

# editing ---------------------------------------------------------------------------------

alias vi='nvim'
alias vim='nvim'

# Easier access to editing particular files (mostly configs).
alias alacrittyrc='nvim ~/.config/alacritty/alacritty.yml'
  alias alarc='alacrittyrc'
alias banlist='vim /mnt/share/documents/banlist.txt'
alias bashrc='nvim ~/.bashrc'
  alias rc='bashrc'
alias dunstrc='nvim ~/.config/dunst/dunstrc'

alias fishrc='nvim ~/.config/fish/config.fish'
alias fishvar='nvim ~/.config/fish/fish_variables'
alias fishprompt='nvim ~/.config/fish/functions/fish_prompt.fish'

alias i3c='nvim ~/.config/i3/config-unique-${HOSTNAME}'
alias i3cc="nvim ~/.config/i3/config-shared"
alias i3ccc="nvim /tmp/.i3-config"
alias i3b="nvim ~/.config/i3/i3blocks.conf"

alias readme='nvim ~/.github/README.md'

# Easy editing and committing of todo list.
alias gcut='cd ~/notes/ && git add ./todo.md && git commit -m "Update todo" && git push'
alias todo='cd ~/notes/ && git pull && nvim ./todo.md && gcut'

alias tmuxrc='nvim ~/.config/tmux/tmux.conf'
alias vimrc='nvim ~/.config/nvim/init.vim'

alias xdefaults='nvim ~/.Xdefaults'
alias xinitrc='nvim ~/.xinitrc'
alias xprofile='nvim ~/.xprofile'

alias youtube='vim /mnt/share/documents/scripting/youtube-dl-urls.txt'

# Encourage use of non-deprecated tools. -------------------------------------------------

alias netstat='echo use \"ss\" or \"lsof -i\" --- netstat is deprecated ---'

# Custom git alias for managing dotfiles. ------------------------------------------------
# See: https://developer.atlassian.com/blog/2016/02/best-way-to-store-dotfiles-git-bare-repo/

os=$(uname) # Store the result of `uname` in a var since this file will check it multiple times.

if [[ ${os} == "FreeBSD" ]]; then
    # FreeBSD's Git binary is at a different path than on Linux.
    alias dot='/usr/local/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'
else
    # "dot" for "dotfiles".
    alias dot='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'
fi

alias d='dot'
alias da='dot add'
alias dau='dot add -u'
alias db='dot branch'
alias dm='dot merge'
alias dc='dot commit'
alias dch='dot checkout'
alias ddd='dot diff'
alias ddi='dot diff'
alias dl='dot log'
alias dp='dot push'
alias dpu='dot pull'
alias dr='dot rm'
alias ds='dot status --untracked-files=no'

# git ------------------------------------------------------------------------------------

alias g='git'
alias ga='git add'
alias gau='git add -u'    # Stage all modified files.
alias gaa='git add -A :/' # Stage all changes, including added or deleted files.
alias gb='git branch'
alias gc='git commit'
alias gch='git checkout'
alias gd='git diff'
alias gf='git fetch'
alias gl='git log'
alias gp='git push'
alias gpu='git pull'
alias gr='git rm'
alias gs='git status'

# ssh ------------------------------------------------------------------------------------

alias e2g='ssh 10.0.0.15'
alias eris='ssh austin@10.0.0.11'

# apps and games -------------------------------------------------------------------------

alias define='dict'
alias eve='bash /opt/evesetup/lib/evelauncher/evelauncher.sh &'
alias osrs='bash /mnt/tank/share/software/gaming/games/runescape-launcher/osrs/bin/osrs-launcher &'
  alias runescape='osrs'
  alias rs='osrs'
  alias snip='scrot --quality 100 --select --freeze --silent'
alias audible='bash /opt/OpenAudible/OpenAudible &'

# directory traversal ---------------------------------------------------------------------

alias r='ranger_cd'

alias u='cd ../'       # "Up 1 directory."
alias u1='u'
alias u2='cd ../../'
alias u3='cd ../../../'
alias u3='cd ../../../../'

alias root='cd /'
alias home='cd ~'
alias h='cd ~'
alias c='clear'

alias linux="cd ~/linux-notes && r"
alias notes="cd ~/notes/ && r"
alias scripts='cd ~/scripts/bash/ && r'
alias status='cd ~/.config/i3/scripts/status-bar/ && r'

if [[ ${os} == "FreeBSD" ]]; then
  alias ls='ls -FCGh' # FreeBSD's ls uses a different syntax from Linux.
  alias sed='gsed'    # Force FreeBSD to use GNU's version of sed.
else

    # The below aliases are Linux-only.

    alias grep='grep --color=auto'
    alias cp='cp --verbose'
    alias mv='mv --verbose'
    alias mkdir='mkdir --parents --verbose -Z'

    alias ls='ls --classify --color=auto --human-readable'
    alias l='ls'
    alias lr='ls --classify --color=auto --human-readable --reverse'
    alias lsr='lr'

    alias ll='ls --classify --color=auto --human-readable -l'           # Show single-column.
    alias llr='ls --classify --color=auto --human-readable -l --reverse'
    alias la='ls --classify --color=auto --human-readable -l --all'
    alias lar='ls --classify --color=auto --human-readable -l --all --reverse'
    alias lss='ls --classify --color=auto --human-readable -l --all -S' # Sort by size.

    alias less='less -XRF' # Show text in terminal even after quitting less.

    alias lcon='ls -lZ --all --reverse'
    alias untar='tar -xzvf'
fi

# OPTIONS #################################################################################

# Use vi-style editing for bash commands.
set -o vi

# FreeBSD uses a different path for the Bash binary.
if [[ ${os} == "FreeBSD" ]]; then
    export SHELL='/usr/local/bin/bash'
else
    export SHELL='/bin/bash'
fi

export TERM='screen-256color'
export LC_CTYPE='en_US.UTF-8'
export PAGER='less'
export BROWSER='firefox'

#  Linux path                 FreeBSD path
if [[ -x /usr/bin/nvim ]] || [[ -x /usr/local/bin/nvim ]]; then
    export EDITOR='/usr/bin/nvim'
    export SUDO_EDITOR='/usr/bin/nvim'
elif [[ -x /usr/bin/vim ]] || [[ -x /usr/local/bin/vim ]]; then
    export EDITOR='/usr/bin/vim'
    export SUDO_EDITOR='/usr/bin/vim'
else
    export EDITOR='/usr/bin/vi'
    export SUDO_EDITOR='/usr/bin/vi'
fi

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
# Ignore duplicates, 'ls' without options, and builtin commands.
export HISTCONTROL=ignoredups
export HISTCONTROL=ignoreboth
export PROMPT_COMMAND='history -a'

shopt -s histappend      # Append history rather than overwriting it.
shopt -q -s cmdhist      # Combine multiline commands into one in history.
shopt -q -s checkwinsize # Check window size after each command and update values of LINES and COLUMNS.
shopt -s cdspell         # Correct minor cd typos.

# RANGER ##################################################################################

# Automatically change the current working directory after closing ranger
# This is a shell function to automatically change the current working
# directory to the last visited one after ranger quits.

ranger_cd() {
    temp_file="$(mktemp -t "ranger_cd.XXXXXXXXXX")"
    ranger --choosedir="$temp_file" -- "${@:-$PWD}"
    if chosen_dir="$(cat -- "$temp_file")" && [[ -n "$chosen_dir" ]] && [[ "$chosen_dir" != "$PWD" ]]
    then
        cd -- "$chosen_dir" || exit 1
    fi
    rm -f -- "$temp_file"
}

# PROMPT ##################################################################################

if [[ ${USER} == "root" ]]; then
    # Make root's prompt red to easily distinguish root from a standard user.
    PS1='\[\033[01;31m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    # Make standard users' prompts green.
    PS1='\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
fi
