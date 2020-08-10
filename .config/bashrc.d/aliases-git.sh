# Sourced by bashrc.
#
# Custom Git aliases for managing dotfiles.
# See: https://developer.atlassian.com/blog/2016/02/best-way-to-store-dotfiles-git-bare-repo/

if [[ "${OSTYPE}" == "linux"* ]]; then
    alias dot='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'
elif [[ "${OSTYPE}" == "freebsd"* ]]; then
    # FreeBSD's Git binary is at a different path than on Linux.
    alias dot='/usr/local/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'
fi

# Easy editing and committing of todo list.
alias gcut='cd ~/notes/ && git commit -m "Update todo" ./todo.md && git push'
alias todo='cd ~/notes/ && git pull && nvim ./todo.md && gcut'

# "dot" for "dotfiles".
alias d='dot'
alias da='dot add'
alias daa='dot add -A ./'
alias dau='dot add -u ./'
alias db='dot branch'
alias dc='dot commit'
alias dcm='dot commit --message'
alias dch='dot checkout'
alias ddi='dot diff'
alias dl='dot log'
alias dm='dot merge'
alias dp='dot push'
alias dpu='dot pull'
alias drm='dot rm'
alias dr='dot restore'
alias drs='dot restore --staged'
alias ds='dot status --untracked-files=no'
alias dss='dot status'

alias g='git'
alias ga='git add'
# Stage all modified files.
alias gau='git add -u ./'
# Stage all changes below the given path, including added or deleted files.
alias gaa='git add -A ./'
alias gb='git branch'
alias gc='git commit'
alias gcm='git commit --message'
alias gch='git checkout'
alias gd='git diff'
alias gdi='git diff'
alias gf='git fetch'
alias gl='git log'
alias gp='git push'
alias gpu='git pull'
alias gr='dot restore'
alias grm='git rm'
alias grs='dot restore --staged'
alias gs='git status'
