#!/bin/bash

# screen locker for waking up from suspend (see ~/.config/i3/config)
# requires the i3lock-color package

i3lock --blur=5 --show-failed-attempts --indicator --force-clock --radius 250 --ring-width 20  --timecolor=ffffffff --verifcolor=ffffffff --wrongcolor=ffffffff --layoutcolor=ffffffff --datecolor=ffffffff --datestr="%a  %Y-%m-%d" --timepos="(w/2):(h/2.5)"
