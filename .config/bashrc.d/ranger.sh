# Sourced by bashrc.
#
# Automatically change the current working directory after closing ranger.

alias r='ranger_cd'
ranger_cd() {
    temp_file="$(mktemp -t "ranger_cd.XXXXXXXXXX")"
    ranger --choosedir="$temp_file" -- "${@:-$PWD}"
    if chosen_dir="$(cat -- "$temp_file")" && [[ -n "$chosen_dir" ]] && [[ "$chosen_dir" != "$PWD" ]]
    then
        cd -- "$chosen_dir" || exit 1
    fi
    rm -f -- "$temp_file"
}
