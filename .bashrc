# ~/.bashrc. Executed by bash when launching interactive non-login shells.
# shellcheck disable=1090 disable=2034

tty="$(tty)"

# Source bashrc scripts.
set globstar
for file in ~/.config/bashrc.d/**.sh; do
  source "${file}"
done
unset globstar
