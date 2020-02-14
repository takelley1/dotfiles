#!/bin/fish

fish_vi_key_bindings # use vi mode keybindings
set -U fish_greeting # don't print default greeting

alias ta='tmux -f ~/.config/tmux/tmux.conf attach'
alias tmux='tmux -f ~/.config/tmux/tmux.conf'
alias vi='nvim'      
alias vim='nvim'      

# editing #################################################################################

# easier access to editing particular files (mostly configs)
alias alacrittyrc='nvim ~/.config/alacritty/alacritty.yml'
alias banlist='vim /mnt/share/documents/banlist.txt'

alias bashrc='nvim ~/.bashrc'
alias fishrc='nvim ~/.config/fish/config.fish'
alias fishprompt='nvim ~/.config/fish/functions/fish_prompt.fish'
alias fishvar='nvim ~/.config/fish/fish_variables'

alias dunstrc='nvim ~/.config/dunst/dunstrc'

alias i3c="nvim ~/.config/i3/config-unique-(hostname)"
alias i3cc="nvim ~/.config/i3/config-shared"
alias i3ccc="nvim ~/.config/i3/config"
alias i3b="nvim ~/.config/i3/i3blocks.conf"

alias linux="cd ~/linux-notes"
alias notes="cd ~/notes/personal"

alias readme='nvim ~/.github/README.md'

# easy editing and committing of todo list
alias todo='cd ~/notes/personal/ && nvim ./todo.md'
alias gcut='cd ~/notes/personal/ && git add ./todo.md && git commit -m "Update todo" && git push'

alias tmuxrc='nvim ~/.tmux.conf'
alias vimrc='nvim ~/.config/nvim/init.vim'

alias xdefaults='nvim ~/.Xdefaults'
alias xprofile='nvim ~/.xprofile'

alias youtube='vim /mnt/share/documents/scripting/youtube-dl-urls.txt'

# encourage use of non-deprecated tools ##################################################

alias netstat='echo use \"ss\" or \"lsof -i\" --- netstat is deprecated ---'
alias ifconfig='echo use \"ip a\" --- ifconfig is deprecated ---'

# custom git aliases used for managing dotfiles ##########################################

# see https://developer.atlassian.com/blog/2016/02/best-way-to-store-dotfiles-git-bare-repo/
alias git-config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'

alias gca='git-config add'
alias gcb='git-config branch'
alias gcc='git-config commit'
alias gcd='git-config diff'
alias gcf='git-config fetch'
alias gcl='git-config log'
alias gco='git-config'
alias gcp='git-config push'
alias gcpu='git-config pull'
alias gcr='git-config rm'
alias gcs='git-config status --untracked-files=no'

# git ####################################################################################

alias ga='git add'
alias gaa='git add -A :/'
alias gb='git branch'
alias gc='git commit'
alias gd='git diff'
alias gf='git fetch'
alias gl='git log'
alias gp='git push'
alias gpu='git pull'
alias gr='git rm'
alias gs='git status'

# ssh ####################################################################################

alias iop='ssh root@10.0.0.1'
alias squid='ssh root@10.0.0.9'
alias deimos='ssh 10.0.0.31'
alias tethys='ssh 10.0.0.32'
alias eris='ssh austin@10.0.0.11'

# apps and games #########################################################################

alias eve='bash /opt/evesetup/lib/evelauncher/evelauncher.sh'
alias osrs='bash /mnt/tank/share/software/gaming/games/runescape-launcher/osrs/bin/osrs-launcher'
alias audible='bash /opt/OpenAudible/OpenAudible'

# directory traversal #####################################################################

alias r='ranger'
alias ..='cd ../'
alias u1='cd ../'       # "up 1 directory"
alias u2='cd ../../'
alias u3='cd ../../../'
alias root='cd /'
alias home='cd ~'
alias h='cd ~'

# core utilities ##########################################################################

alias grep='grep --color=auto'
alias cp='cp --preserve=all --verbose'
alias mv='mv --verbose'
alias mkdir='mkdir --parents --verbose -Z'

alias ls='ls --classify --color=auto --human-readable'
alias l='ls --classify --color=auto --human-readable'
alias ll='ls --classify --color=auto --human-readable -l'           # show single-column
alias la='ls --classify --color=auto --human-readable -l --all'
alias lss='ls --classify --color=auto --human-readable -l --all -S' # sort by size

alias mount='mount | column -t'

# misc ####################################################################################

alias c='clear'
alias clr='clear'
alias untar='tar -zxvf'
#alias up='sudo apt update && sudo apt upgrade -y'
alias up='sudo pacman -Syu'
alias lcon='ls -lZ --all --reverse'

# variables ###############################################################################

export LC_CTYPE=en_US.UTF-8

export PAGER='less'
export EDITOR='nvim'
export BROWSER='firefox'

# add main bash scripting dir to path
export PATH="$PATH:/home/austin/scripts/bash"

# vars for sxiv image viewer
export XDG_CONFIG_HOME=~/.config
export XDG_CACHE_HOME=~/.cache

