# ~/.bashrc. Executed by bash when launching interactive non-login shells.
# shellcheck disable=1090 disable=2034

tty="$(tty)"

# Source bashrc scripts. Scripts are located in my home directory.
shopt -s globstar  # Source recursively.
shopt -s nullglob  # Set nullglob so the unmatched username glob is not made literal.
bashrc_dir="/home/akelley/.config/bashrc.d"
if [[ -d "${bashrc_dir}" ]]; then
    for file in "${bashrc_dir}"/**.sh; do
        . "${file}"
    done
else
    printf "%s\n" "No bashrc.d directory to source!"
fi
