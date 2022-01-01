#!/usr/bin/env bash
#
# Runs continuously, so dynamically added peripherals receive the correct configuration.

# Have this script replace other instances of itself that are running.
number_of_instances="$(pgrep -f "${0//*\//}" | wc -l)"
# For some reason this only works if we check if the number of processes is over
#   2 instead of over 1.
if [[ ${number_of_instances} -gt 2 ]]; then
    pgrep -f "${0//*\//}" | sort -n -r | tail -n +2 | xargs kill -s 9
fi

while :; do
    # Set key repeat delay.
    xset r rate 190 50

    # Disable keyboard beeping.
    xset b off

    # Ensure caps lock and right CTRL is configured correctly.
    # xmodmap \
    #     -e "remove Lock = Caps_Lock" \    --- Disable the normal function of the caps lock key
    #     -e "keysym Caps_Lock = Up" \      --- Rebind Caps Lock to the Up arrow
    #     -e "remove Lock = Up" \           --- Disable Caps Lock on the Up arrow
    #     -e "remove control = Control_R" \ --- Disable the normal function of the right CTRL key
    #     -e "add mod3 = Control_R"         --- Map mod3 to right CTRL for usage with i3
    xmodmap \
        -e "remove Lock = Caps_Lock" \
        -e "keysym Caps_Lock = Up" \
        -e "remove Lock = Up" \
        -e "remove control = Control_R" \
        -e "add mod3 = Control_R"

    # Also configure mice and input devices that may get added dynamically.
    # Run `xinput --list-props pointer'POINTER_NAME_HERE'` to get properties.

    # MICE
    xinput --set-prop pointer:'MOSART Semi. 2.4G Keyboard Mouse' 'libinput Accel Speed' -0.55
    xinput --set-prop pointer:'Logitech ERGO M575' 'libinput Accel Speed' -0.5

    # KEYBOARDS
    xinput --set-prop 'ETPS/2 Elantech Touchpad' 'libinput Tapping Enabled' 1 # Enable tap-clicking.
    xinput --set-prop 'ETPS/2 Elantech Touchpad' 'libinput Accel Speed' 0.2   # Increase sensitivity.

    sleep 5s
done
