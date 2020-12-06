#!/usr/bin/env bash
#
# Sourced by bashrc.
#
# Aliases for easily accessing config files and directories.

# Easy editing and committing of todo list.
alias todo='cd ~/notes/ && git pull && nvim ./personal--todo.md && git commit -m "Update todo.md" ./personal--todo.md && git push'

alias fmt='fmt -w 120'

alias alacrittyrc='nvim ~/.config/alacritty/alacritty.yml'
alias banlist='nvim /mnt/share/documents/banlist.txt'
alias bashrc='cd ~/.config/bashrc.d && r'
alias bashrcf='nvim ~/.bashrc'
alias dunstrc='nvim ~/.config/dunst/dunstrc'

alias readme='nvim ~/.github/README.md'
alias tmuxrc='nvim ~/.config/tmux/tmux.conf'
alias vimrc='nvim ~/.config/nvim/init.vim'
alias plugins='cd ~/.local/share/nvim/site/pack/git-plugins/start/ && r'
alias xdefaults='nvim ~/.Xdefaults'
alias xinitrc='nvim ~/.xinitrc'
alias xprofile='nvim ~/.xprofile'

alias i3b='nvim ~/.config/i3/i3blocks.conf'
alias i3c='nvim ~/.config/i3/config-unique-${HOSTNAME}'
alias i3cc='nvim ~/.config/i3/config-shared'
alias i3ccc='nvim /tmp/.i3-config'

alias config='cd ~/.config && r'
alias linux='cd ~/linux-notes && r'
alias notes='cd ~/notes/ && r'
alias roles='cd ~/scripts/ansible/roles && r'
alias scripts='cd ~/scripts/ && r'
alias status='cd ~/.config/i3/scripts/status-bar/ && r'
