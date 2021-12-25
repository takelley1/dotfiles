#!/usr/bin/env dash
#
# Runs xset continuously, so added keyboards receive the correct configuration.

while :; do
    xset r rate 190 50

    # Also configure mice and input devices that may get added dynamically.

    xinput --set-prop pointer:'MOSART Semi. 2.4G Keyboard Mouse' 'libinput Accel Speed' -0.55

    xinput --set-prop 'ETPS/2 Elantech Touchpad' 'libinput Tapping Enabled' 1 # Enable tap-clicking.
    xinput --set-prop 'ETPS/2 Elantech Touchpad' 'libinput Accel Speed' 0.2   # Increase sensitivity.

    sleep 5s
done
