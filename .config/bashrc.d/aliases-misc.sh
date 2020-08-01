# Sourced by bashrc.
#
# Aliases for common utilities and apps.

# "Up 1 directory."
alias u='cd ../'
alias u2='cd ../../'
alias u3='cd ../../../'
alias u3='cd ../../../../'

alias h='cd ~'
alias c='clear'

alias mv='mv -v'
alias cp='cp -v'

# This is required for bash aliases to work with sudo.
alias sudo='sudo '

# Show text in terminal even after quitting less.
alias less='less -XRF' 
alias grep='grep --color=always'
alias mkdir='mkdir -pv'

alias pip='pip --trusted-host pypi.org --trusted-host pypi.python.org --trusted-host files.pythonhosted.org'
alias pip3='pip3 --trusted-host pypi.org --trusted-host pypi.python.org --trusted-host files.pythonhosted.org'
alias pip3.8='pip3.8 --trusted-host pypi.org --trusted-host pypi.python.org --trusted-host files.pythonhosted.org'

alias ta='tmux -f ~/.config/tmux/tmux.conf attach'
alias tmux='tmux -f ~/.config/tmux/tmux.conf'

alias vi='nvim'
alias vim='nvim'

alias define='dict'
alias eve='bash /opt/evesetup/lib/evelauncher/evelauncher.sh &'
alias osrs='bash ~/scripts/bash/linux/osrs.sh &'
  alias runescape='osrs'
  alias rs='osrs'
  alias snip='scrot --quality 100 --select --freeze --silent'
  alias s='bash ~/scripts/bash/linux/ocvbot-sync-manual.sh'
alias audible='bash /opt/OpenAudible/OpenAudible &'
