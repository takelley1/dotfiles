# ~/.bashrc: executed by bash(1) for non-login shells.

# ALIASES #########################################################################################

        # reattach to the last tmux session or create a new one
          # requires "new-session -n $HOST" in ~/.tmux.conf file
        tmux attach
	alias ta='tmux attach'

        # use vi-style editing for bash commands
        set -o vi

	# editing #################################################################################

        alias vi='nvim'      
        alias vim='nvim'      

	# easier access to config files
	alias i3c='nvim ~/.config/i3/config'
        alias i3b="nvim ~/.config/i3/i3blocks-$(hostname).conf"
        alias bashrc='nvim ~/.bashrc'
        alias rc='nvim ~/.bashrc'
        alias xd='nvim ~/.Xdefaults'
        alias xp='nvim ~/.xprofile'
        alias xprofile='nvim ~/.xprofile'
        alias tm='nvim ~/.tmux.conf'
        alias tmuxrc='nvim ~/.tmux.conf'
	alias vm='nvim ~/.config/nvim/init.vim'
	alias vimrc='nvim ~/.config/nvim/init.vim'

	alias todo='cd ~/notes/personal/ && nvim ./todo.md'
	alias gcut='git add ./todo.md && git commit -m "Update todo" && git push'

	alias ban='vim /mnt/share/documents/banlist.txt'
	alias banlist='vim /mnt/share/documents/banlist.txt'
	alias yt='vim /mnt/share/documents/scripting/youtube-dl-urls.txt'
	alias youtube='vim /mnt/share/documents/scripting/youtube-dl-urls.txt'

        # custom git aliases used for backing up dotfiles ########################################

        # see https://developer.atlassian.com/blog/2016/02/best-way-to-store-dotfiles-git-bare-repo/
        alias git-config='/usr/bin/git --git-dir=/home/austin/.cfg/ --work-tree=/home/austin/'

	alias gco='git-config'
	alias gcd='git-config diff'
	alias gcs='git-config status --untracked-files=no'
	alias gca='git-config add'
	alias gcr='git-config rm'
	alias gcc='git-config commit'
	alias gcp='git-config push'
	alias gcpu='git-config pull'
	alias gcf='git-config fetch'
	alias gcl='git-config log'

	# git ####################################################################################

	alias gd='git diff'
	alias gs='git status'
	alias ga='git add'
	alias gr='git rm'
	alias gc='git commit'
	alias gp='git push'
	alias gpu='git pull'
	alias gf='git fetch'
	alias gl='git log'

	# ssh ####################################################################################

	alias iop='ssh root@10.0.0.1'
	alias squid='ssh root@10.0.0.9'
	alias deimos='ssh 10.0.0.31'
	alias tethys='ssh 10.0.0.32'
	alias eris='ssh 10.0.0.11'

	# apps and games #########################################################################

	alias eve='bash /opt/evesetup/lib/evelauncher/evelauncher.sh'
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

	# grep ####################################################################################

        alias grep='grep --color=auto'
        alias hgrep="history | grep "
        alias pgrep="ps aux | grep "
        alias mgrep="cat /var/log/messages | grep "
        alias sgrep="cat /var/log/secure | grep "

	# networking

        alias fping='ping -c 100 -s.2'
        alias ports='netstat -tulanp'

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

# FORMATTING  #####################################################################################

        # colored manpages
        export LESS_TERMCAP_mb=$'\E[01;31m'
        export LESS_TERMCAP_md=$'\E[01;31m'
        export LESS_TERMCAP_me=$'\E[0m'
        export LESS_TERMCAP_se=$'\E[0m'
        export LESS_TERMCAP_so=$'\E[01;44;33m'
        export LESS_TERMCAP_ue=$'\E[0m'
        export LESS_TERMCAP_us=$'\E[01;32m'

        # combine multiline commands into one in history
        shopt -s cmdhist

        export EDITOR='nvim'

	# history modifications
        export HISTIGNORE="&:ls:[bf]g:exit"
        export HISTFILESIZE=200000
        export HISTSIZE=100000
        shopt -s histappend

        # ignore duplicates, 'ls' without options, and builtin commands
        HISTCONTROL=ignoredups
        HISTCONTROL=ignoreboth

        # append history instead of overwriting it
        shopt -s histappend
        PROMPT_COMMAND='history -a'

        # check the window size after each command and, if necessary,
        # update the values of LINES and COLUMNS.
        shopt -s checkwinsize

###################################################################################################

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

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# if this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# alias definitions
# you may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly
# see /usr/share/doc/bash-doc/examples in the bash-doc package

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc)
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

