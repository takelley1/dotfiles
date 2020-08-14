#!/usr/bin/env dash

# Standard screen locker that can be invoked manually or after waking from suspend (see ~/.config/i3/config).
# Requires the i3lock-color package.

i3lock                       \
    --ignore-empty-password  \
    --show-failed-attempts   \
    --bar-indicator          \
    --bar-max-height 300     \
    --bar-step 300           \
    --bar-width=40           \
    --force-clock            \
    --color=000000           \
    --timecolor=ffffffff     \
    --verifcolor=ffffffff    \
    --wrongcolor=ffffffff    \
    --layoutcolor=ffffffff   \
    --datecolor=ffffffff     \
    --datestr="%A, %Y-%m-%d" \
    --datepos="(w/2):(h/2.5)"\
    --date-font=sans-serif   \
    --datesize=30            \
    --timestr="%H:%H"        \
    --timepos="(w/2):(h/3)"  \
    --time-font=sans-serif   \
    --timesize=40            \
    --refresh-rate=10
