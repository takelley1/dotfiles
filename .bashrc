# ~/.bashrc. Executed by bash when launching interactive non-login shells.

####################################################################################################
# COMMON CONFIGURATION
####################################################################################################
# Configuration that is shared by both FreeBSD and Linux.

# STARTUP ==========================================================================================
os="$(uname)" # Store the result of `uname` in a var since this file will check it multiple times.
tty="$(tty)"

# Start X without a display manager if logging into tty1 with a non-root account.
if [[ "${os}" == "Linux"
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

# ALIASES ==========================================================================================

alias ta='tmux -f ~/.config/tmux/tmux.conf attach'
alias tmux='tmux -f ~/.config/tmux/tmux.conf'

# EDITING ------------------------------------------------------------------------------------------

alias vi='nvim'
alias vim='nvim'

# Easier access to editing particular files (mostly configs).
alias alacrittyrc='nvim ~/.config/alacritty/alacritty.yml'
  alias alarc='alacrittyrc'
alias banlist='vim /mnt/share/documents/banlist.txt'
alias bashrc='nvim ~/.bashrc'
  alias rc='bashrc'
alias dunstrc='nvim ~/.config/dunst/dunstrc'

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

alias d='dot'
alias da='dot add'
alias dau='dot add -u'
alias daa='dot add -A'
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
alias dss='dot status'

# GIT ----------------------------------------------------------------------------------------------

alias g='git'
alias ga='git add'
alias gau='git add -u'  # Stage all modified files.
alias gaa='git add -A'  # Stage all changes below the given path, including added or deleted files.
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

# SSH ----------------------------------------------------------------------------------------------

alias europa='ssh 10.0.0.15'
alias eris='ssh austin@10.0.0.11'
alias rhea='ssh root@10.0.0.4'
#alias orion='ssh root@10.0.0.'

# APPS AND GAMES -----------------------------------------------------------------------------------

alias define='dict'
alias eve='bash /opt/evesetup/lib/evelauncher/evelauncher.sh &'
alias osrs='bash ~/scripts/bash/linux/osrs.sh &'
  alias runescape='osrs'
  alias rs='osrs'
  alias snip='scrot --quality 100 --select --freeze --silent'
  alias s='bash ~/scripts/bash/linux/ocvbot-sync-manual.sh'
alias audible='bash /opt/OpenAudible/OpenAudible &'
alias pass='systemctl stop auto-screenshot.service && pass'

# DIRECTORY TRAVERSAL ------------------------------------------------------------------------------

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

alias mv='mv -v'
alias cp='cp -v'

# MISC ---------------------------------------------------------------------------------------------

alias linux="cd ~/linux-notes && r"
alias notes="cd ~/notes/ && r"
alias scripts='cd ~/scripts/bash/ && r'
alias status='cd ~/.config/i3/scripts/status-bar/ && r'

# This is required for bash aliases to work with sudo.
alias sudo='sudo '

alias less='less -XRF' # Show text in terminal even after quitting less.
alias grep='grep --color=always'
alias mkdir='mkdir -pv'

alias pip='pip --trusted-host pypi.org --trusted-host pypi.python.org --trusted-host files.pythonhosted.org'
alias pip3='pip3 --trusted-host pypi.org --trusted-host pypi.python.org --trusted-host files.pythonhosted.org'
alias pip3.8='pip3.8 --trusted-host pypi.org --trusted-host pypi.python.org --trusted-host files.pythonhosted.org'

# OPTIONS ==========================================================================================

# Use vi-style editing for bash commands.
set -o vi

export TERM='screen-256color'
export PAGER='less'
export BROWSER='firefox'

# Add scripts to PATH
export PATH=$PATH:~/scripts/bash
export PATH=$PATH:~/scripts/bash/freebsd

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

if [[ "${os}" == "FreeBSD" ]]; then
  # Custom Git alias for managing dotfiles.
  # See: https://developer.atlassian.com/blog/2016/02/best-way-to-store-dotfiles-git-bare-repo/
  # FreeBSD's Git binary is at a different path than on Linux.
  # "dot" for "dotfiles".
  alias dot='/usr/local/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'

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

elif [[ "${os}" == "Linux" ]]; then
  alias dot='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'

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
