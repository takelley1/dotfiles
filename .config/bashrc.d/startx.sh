# Sourced by bashrc.
#
# Start X without a display manager if logging into tty1 with a non-root account.
#
# shellcheck disable=2154

if [[ "${OSTYPE}" == "linux-gnu"
  && ! "${USER}" == "root"
  && -z "${DISPLAY}"
  && "${tty}" == "/dev/tty1" ]]; then
  exec startx
fi
