# Sourced by bashrc.

# Reattach to the last tmux session or create a new one if it doesn't exist.
#   Requires "new-session -n $HOST" in ~/.tmux.conf file.
#   Only runs if tmux isn't already attached and if not using tty2.
#
# shellcheck disable=2154

if [[ ! "${USER}" == "root" && -z "${TMUX}" && ! "${tty}" == "/dev/tty2" ]]; then
    if hash tmux 2>/dev/null; then
        exec tmux -f "${HOME}/.config/tmux/tmux.conf" attach
    fi
fi
