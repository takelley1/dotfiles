# Sourced by bashrc.
#
# Linux-specific aliases and environment variables.

if [[ "${OSTYPE}" == "linux"* ]]; then

    export SHELL="/bin/bash"

    # Easily start/stop automounts.
    function mnt() {
        # shellcheck disable=2046
        systemctl "${@}" \
        $(systemctl list-units mnt*.*mount --type=automount --plain --no-legend --no-pager | awk '{ORS=" "}; {print $1}') 2>/dev/null
    }

    alias l='ls --classify --color=auto --human-readable'
    alias ls='l'
    alias lr='l --reverse'
    alias lsr='lr'
    alias ll='l -l'
    alias la='l -l --all'
    alias lar='l -l --all --reverse'
    # Sort by size.
    alias lss='l -l --all -S'

    alias lcon='l -lZ --all --reverse'
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
