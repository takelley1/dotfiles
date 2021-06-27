#!/usr/bin/env dash

# Standard screen locker that can be invoked manually or after waking
#   from suspend (see ~/.config/i3/config).
# Requires the i3lock-color package.

i3lock                         \
    --ignore-empty-password    \
    --show-failed-attempts     \
    --bar-indicator            \
    --bar-max-height 300       \
    --bar-step 300             \
    --bar-width=40             \
    --force-clock              \
    --color=000000             \
    --time-color=ffffffff      \
    --verif-color=ffffffff     \
    --wrong-color=ffffffff     \
    --layout-color=ffffffff    \
    --date-color=ffffffff      \
    --date-str="%A, %Y-%m-%d"  \
    --date-pos="(w/2):(h/2.5)" \
    --date-font=sans-serif     \
    --date-size=30             \
    --time-str="%H:%H"         \
    --time-pos="(w/2):(h/3)"   \
    --time-font=sans-serif     \
    --time-size=40             \
    --refresh-rate=10
