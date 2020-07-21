#!/usr/bin/env dash
# ~/.xinitrc
# Executed by shell to start the X user session.

userresources="${HOME}/.Xresources"
usermodmap="${HOME}/.Xmodmap"
sysresources="/etc/X11/xinit/.Xresources"
sysmodmap="/etc/X11/xinit/.Xmodmap"

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

# Create i3 config and launch i3.
cat "${HOME}/.config/i3/.config-notification"      \
    "${HOME}/.config/i3/config-unique-$(hostname)" \
    "${HOME}/.config/i3/config-shared"             \
    > /tmp/.i3-config                              \
    && exec i3 -c /tmp/.i3-config
