# ~/.bashrc: executed by bash(1) for non-login shells.

# COMMANDS ###################################################################

        # reattach to the last tmux session or create a new one
          # requires "new-session -n $HOST" in ~/.tmux.conf file
        tmux attach
	alias ta='tmux attach'

        # use vi-style editing for bash commands
        set -o vi

	# edit configuration files
	alias i3c='nvim ~/.config/i3/config'
        alias i3b="nvim ~/.config/i3/i3blocks-$(hostname).conf"
        alias bashrc='nvim ~/.bashrc'
        alias rc='nvim ~/.bashrc'
        alias xd='nvim ~/.Xdefaults'
        alias xp='nvim ~/.xprofile'
        alias tm='nvim ~/.tmux.conf'

        # custom git aliases used for backing up dotfiles ######################
        # see https://developer.atlassian.com/blog/2016/02/best-way-to-store-dotfiles-git-bare-repo/

        alias git-config='/usr/bin/git --git-dir=/home/austin/.cfg/ --work-tree=/home/austin'

	#alias gc='git-config' # conflicts with "alias gc=git commit"
	alias gcd='git-config diff'
	alias gcs='git-config status --untracked-files=no'
	alias gca='git-config add'
	alias gcc='git-config commit'
	alias gcp='git-config push'
	alias gcl='git-config log'

	# SSH ALIASES ########################################################

	alias iop='ssh root@10.0.0.1'
	alias squid='ssh root@10.0.0.9'
	alias syslog='ssh root@10.0.0.10'
	alias tethys='ssh austin@tethys'
	alias borg='ssh root@10.0.0.11'

	######################################################################

	# apps and games
	alias eve='bash /opt/evesetup/lib/evelauncher/evelauncher.sh'
	alias audible='bash /opt/OpenAudible/OpenAudible'
	
	# git
	alias gd='git diff'
	alias gs='git status'
	alias ga='git add'
	alias gc='git commit' # conflicts with "alias gc=git-config"
	alias gp='git push'
	alias gl='git log'

	# packages
	#alias up='sudo apt update && sudo apt upgrade -y'
	alias up='sudo pacman -Syu'

	# text editors
        alias vi='nvim'      
        alias vim='nvim'      

	# directory traversal
	alias r='ranger'
        alias ..='cd ../'
        alias ...='cd ../../../'
        alias root='cd /'
        alias home='cd ~'

        # show SELinux contexts
        alias lcon='ls -lZ --all --reverse'

	# grep modifications
        alias grep='grep --color=auto'
        alias hgrep="history | grep "
        alias pgrep="ps aux | grep "
        alias mgrep="cat /var/log/messages | grep "
        alias sgrep="cat /var/log/secure | grep "

	# networking
        alias fping='ping -c 100 -s.2'
        alias ports='netstat -tulanp'

	alias proxy='export {http,ftp,https}_proxy="http://10.0.0.9:3128/'
	alias noproxy='unset {http,ftp,https}_proxy'

	# standard utilities
        #alias cp='cp --recursive -d --preserve=all --verbose'
	alias mv='mv --verbose'
        alias mkdir='mkdir --parents --verbose -Z'

        alias h='history'
        alias mount='mount | column -t'
        alias m='mount | column -t'

        # add colors to ls
        alias ls='ls -C --classify --color=auto'
        alias la='ls -a  --reverse --human-readable'
        alias ll='ll --human-readable'
        alias l='ls'
        # sort by size
        alias lss='ls -S --reverse --human-readable'

        alias j='jobs -l'
        alias c='clear'
        alias untar='tar -zxvf'

# FORMATTING  ################################################################

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

##############################################################################

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

