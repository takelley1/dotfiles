#!/bin/bash

# Standard screen locker that can be invoked manually or after waking from suspend (see ~/.config/i3/config).
# Requires the i3lock-color package.

i3lock                       \
    --show-failed-attempts   \
    --bar-indicator          \
    --bar-max-height 25      \
    --bar-step 25            \
    --bar-periodic-step 25   \
    --force-clock            \
    --color=000000           \
    --timecolor=ffffffff     \
    --verifcolor=ffffffff    \
    --wrongcolor=ffffffff    \
    --layoutcolor=ffffffff   \
    --datecolor=ffffffff     \
    --datestr="%a  %Y-%m-%d" \
    --timestr="%H:%H"        \
    --timepos="(w/2):(h/2.5)"
