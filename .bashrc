# ~/.bashrc, executed by bash when launching interactive non-login shells
# place stuff here that only applies to bash itself

# STARTUP #########################################################################################

        # reattach to the last tmux session or create a new one
        if [ ! $USER == "root" ] # only auto-attach in non-root shells
        then
                # requires "new-session -n $HOST" in ~/.tmux.conf file
                # only runs if tmux isn't already attached
                [[ -z $TMUX ]] && exec tmux -f ~/.config/tmux/tmux.conf attach
        fi

        exec fish # try out the fish shell instead of bash

        # use vi-style editing for bash commands
        set -o vi

# ALIASES #########################################################################################

        alias ta='tmux -f ~/.config/tmux/tmux.conf attach'
        alias tmux='tmux -f ~/.config/tmux/tmux.conf'
        alias vi='nvim'      
        alias vim='nvim'      

        # editing #################################################################################

        # easier access to editing particular files (mostly configs)
        alias alacrittyrc='nvim ~/.config/alacritty/alacritty.yml'
        alias banlist='vim /mnt/share/documents/banlist.txt'
        alias bashrc='nvim ~/.bashrc'
        alias dunstrc='nvim ~/.config/dunst/dunstrc'

        alias i3c="nvim ~/.config/i3/config-unique-$(hostname)"
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
        if [ $(uname) == "FreeBSD" ]
            then
                # FreeBSD's "git" binary is located at a different path than on Linux
                alias git-config='/usr/local/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'
            else
                alias git-config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'
        fi

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

        if [ $(uname) == "FreeBSD" ]
        then
          alias ls='ls -FCGh' # FreeBSD's "ls" uses a different syntax from Linux
        else # the below aliases are Linux-only

          # grep ####################################################################################
  
          alias grep='grep --color=auto'
          alias hgrep="history | grep "
          alias pgrep="ps aux | grep "
          alias mgrep="cat /var/log/messages | grep "
          alias sgrep="cat /var/log/secure | grep "
  
          # networking
  
          alias fping='ping -c 100 -s.2'
          alias ports='ss -plaunt'
  
          # core utilities ##########################################################################
  
          alias cp='cp --preserve=all --verbose'
          alias mv='mv --verbose'
          alias mkdir='mkdir --parents --verbose -Z'
  
          alias ls='ls --classify --color=auto --human-readable'
          alias l='ls --classify --color=auto --human-readable'
          alias ll='ls --classify --color=auto --human-readable -l'           # show single-column
          alias la='ls --classify --color=auto --human-readable -l --all'
          alias lss='ls --classify --color=auto --human-readable -l --all -S' # sort by size
  
          alias hi='history'
          alias his='history'
          alias mount='mount | column -t'
          alias m='mount | column -t'
  
          # misc ####################################################################################
  
          alias j='jobs -l'
          alias c='clear'
          alias clr='clear'
          alias untar='tar -zxvf'
          #alias up='sudo apt update && sudo apt upgrade -y'
          alias up='sudo pacman -Syu'
          alias lcon='ls -lZ --all --reverse'
        fi

# MISC ############################################################################################

# if not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# make 'less' more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

if [ $USER == "root" ]
then
        # make the root red to distinguish it from the standard user
        PS1='${debian_chroot:+($debian_chroot)}\[\033[01;31m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
        # make the standard prompt green
        PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
fi

