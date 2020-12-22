#!/usr/bin/env bash
#
# Sourced by bashrc.
#
# Custom Git aliases for managing dotfiles.
# See: https://developer.atlassian.com/blog/2016/02/best-way-to-store-dotfiles-git-bare-repo/
alias dot='git --git-dir=$HOME/.cfg/ --work-tree=$HOME'

# -----------------------------------------------------------------------------

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

alias dl='dot log --graph --oneline --full-history --abbrev-commit --all --color --decorate --pretty=format:"%x1b[31m%h%x09%x1b[32m%d%x1b[0m%x20%s"'
alias gl='git log --graph --oneline --full-history --abbrev-commit --all --color --decorate --pretty=format:"%x1b[31m%h%x09%x1b[32m%d%x1b[0m%x20%s"'

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
