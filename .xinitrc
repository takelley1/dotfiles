#!/bin/sh
# ~/.xinitrc
# Executed by /bin/sh to start the X user session.

userresources=$HOME/.Xresources
usermodmap=$HOME/.Xmodmap
sysresources=/etc/X11/xinit/.Xresources
sysmodmap=/etc/X11/xinit/.Xmodmap

# Merge in defaults and keymaps.
if [ -f $sysresources ]; then
    xrdb -merge $sysresources
fi

if [ -f $sysmodmap ]; then
    xmodmap $sysmodmap
fi

if [ -f "$userresources" ]; then
    xrdb -merge "$userresources"
fi

if [ -f "$usermodmap" ]; then
    xmodmap "$usermodmap"
fi

if [ -d /etc/X11/xinit/xinitrc.d ] ; then
 for f in /etc/X11/xinit/xinitrc.d/?*.sh ; do
  [ -x "$f" ] && . "$f"
 done
 unset f
fi

# Create i3 config.
rm -f /tmp/.i3-config
cat "${HOME}/.config/i3/.config-notification" "${HOME}/.config/i3/config-unique-$(hostname)" "${HOME}/.config/i3/config-shared" > /tmp/.i3-config

# Take screenshots on all hosts but phobos.
if [ ! "$(hostname)" = "phobos" ]
then
    # Kill any previous instances of the auto-screenshot script.
    kill -s 9 "$(pgrep -f auto-screenshot.sh)" ; \
    # Start auto-screenshot script.
      # The '&' is required or the window manager will not start.
    bash "${HOME}/scripts/bash/auto-screenshot.sh" &>> "${HOME}/Pictures/auto-screenshot.log" &
fi

# Force manual fan control on Dell laptops.
if [ "$(hostname)" = "deimos" ]; then
  modprobe i8k force=1 &
fi

# Start window manager.
exec i3 -c /tmp/.i3-config
