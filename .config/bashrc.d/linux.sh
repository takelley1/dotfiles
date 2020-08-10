# Sourced by bashrc.
#
# Linux-specific aliases and environment variables.

if [[ "${OSTYPE}" == "linux"* ]]; then

    export SHELL="/bin/bash"

    function stop-automount() {
        systemctl stop "$(systemctl | awk '{ORS=" "}; /^  mnt.*automount/ {print $1}')" 2>/dev/null
    }

    alias ls='ls --classify --color=auto --human-readable'
    alias l='ls'
    alias lr='ls --classify --color=auto --human-readable --reverse'
    alias lsr='lr'

    # Show single-column.
    alias ll='ls --classify --color=auto --human-readable -l'

    alias llr='ls --classify --color=auto --human-readable -l --reverse'
    alias la='ls --classify --color=auto --human-readable -l --all'
    alias lar='ls --classify --color=auto --human-readable -l --all --reverse'

    # Sort by size.
    alias lss='ls --classify --color=auto --human-readable -l --all -S'

    alias lcon='ls -lZ --all --reverse'
    alias untar='tar -xzvf'

    if hash nvim 2>/dev/null; then
        export EDITOR="/usr/bin/nvim"
        export VISUAL="/usr/bin/nvim"
        export SUDO_EDITOR="/usr/bin/nvim"
    elif hash vim 2>/dev/null; then
        export EDITOR="/usr/bin/vim"
        export VISUAL="/usr/bin/vim"
        export SUDO_EDITOR="/usr/bin/vim"
    else
        export EDITOR="/usr/bin/vi"
        export VISUAL="/usr/bin/vi"
        export SUDO_EDITOR="/usr/bin/vi"
    fi
fi
