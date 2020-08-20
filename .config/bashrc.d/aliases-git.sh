# Sourced by bashrc.
#
# Custom Git aliases for managing dotfiles.
# See: https://developer.atlassian.com/blog/2016/02/best-way-to-store-dotfiles-git-bare-repo/
alias dot='git --git-dir=$HOME/.cfg/ --work-tree=$HOME'

# Easy editing and committing of todo list.
alias todo='cd ~/notes/ && git pull && nvim ./todo.md && git commit -m "Update todo.md" ./todo.md && git push'

# -----------------------------------------------------------------------------

alias d='dot'
alias da='dot add'
alias daa='dot add --all ./'
alias daaa='dot add --all'
alias dau='dot add --update ./'
alias dauu='dot add --update'
alias db='dot branch'
alias dcs='dot commit'
alias dcam='dot commit --all --message'
alias dch='dot checkout'
alias dcm='dot commit --message'
alias di='dot diff'
alias dis='dot diff --staged'
alias dl='dot log'
alias dm='dot merge'
alias dp='dot push'
alias dpu='dot pull'
alias dr='dot restore'
alias drm='dot rm'
alias drs='dot restore --staged'
alias ds='dot status --untracked-files=no'
alias dss='dot status'
function dcamp {
dot commit --all --message "${@}" && dot push
}
function dcmp {
dot commit --message "${@}" && dot push
}

# -----------------------------------------------------------------------------

alias g='git'
alias ga='git add'
alias gaa='git add --all ./' # Stage all changes below current path.
alias gaaa='git add --all'   # Stage all changes.
alias gau='git add --update ./' # Add all modified files below current path.
alias gauu='git add --update'   # Add all modified files.
alias gb='git branch'
alias gcs='git commit'
alias gca='git commit --all'
alias gcam='git commit --all --message'
alias gch='git checkout'
alias gcm='git commit --message'
alias gi='git diff'
alias gis='git diff --staged'
alias gl='git log'
alias gp='git push'
alias gpu='git pull'
alias gr='dot restore'
alias grm='git rm'
alias grs='dot restore --staged'
alias gs='git status'
function gcamp {
git commit --all --message "${@}" && git push
}
function gcmp {
git commit --message "${@}" && git push
}
