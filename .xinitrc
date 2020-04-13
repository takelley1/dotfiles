#!/bin/bash
# ~/.xinitrc
# Executed by shell to start the X user session.

userresources=$HOME/.Xresources
usermodmap=$HOME/.Xmodmap
sysresources=/etc/X11/xinit/.Xresources
sysmodmap=/etc/X11/xinit/.Xmodmap

# Merge in defaults and keymaps.
if [[ -f $sysresources ]]; then
  xrdb -merge $sysresources
fi

if [[ -f $sysmodmap ]]; then
  xmodmap $sysmodmap
fi

if [[ -f "$userresources" ]]; then
  xrdb -merge "$userresources"
fi

if [[ -f "$usermodmap" ]]; then
  xmodmap "$usermodmap"
fi

if [[ -d /etc/X11/xinit/xinitrc.d ]] ; then
  for f in /etc/X11/xinit/xinitrc.d/?*.sh ; do
    [[ -x "$f" ]] && . "$f"
  done
  unset f
fi

# Take screenshots on all hosts but phobos.
if [[ ! "${HOSTNAME}" == "phobos" ]]
then
  # Kill any previous instances of the auto-screenshot script.
  kill -s 9 "$(pgrep -f "${HOME}/scripts/bash/auto-screenshot.sh")" &> /dev/null ; \
  # Start auto-screenshot script.
    # The '&' is required or the window manager will not start.
  bash "${HOME}/scripts/bash/auto-screenshot.sh" &>> "${HOME}/Pictures/auto-screenshot.log" &
fi

if [[ "${HOSTNAME}" == "deimos" ]]; then
  # Force manual fan control on Dell laptops.
  # This requires allowing passwordless sudo for modprobe.
  modprobe i8k force=1 &
  # Start manual fan control script.
  kill -s 9 "$(pgrep -f "${HOME}/scripts/bash/fan.sh")" &> /dev/null ; \
  bash "${HOME}/scripts/bash/fan.sh" &> /dev/null &
fi

# Create i3 config and launch i3.
cat "${HOME}/.config/i3/.config-notification"      \
    "${HOME}/.config/i3/config-unique-${HOSTNAME}" \
    "${HOME}/.config/i3/config-shared"             \
    > /tmp/.i3-config \
    && exec i3 -c /tmp/.i3-config
