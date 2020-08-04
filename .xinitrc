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

# Ensure i3 running config file is empty.
>/tmp/.i3-config

# Build i3 config file out of a shared common configuration and a
#   separate configuration unique to the current host.
cat "${HOME}/.config/i3/.config-notification"      \
    "${HOME}/.config/i3/config-unique-$(hostname)" \
    "${HOME}/.config/i3/config-shared"             \
    > /tmp/.i3-config

# Launch i3 using the temporary "running config" file.
exec i3 -c /tmp/.i3-config
