#!/bin/bash

# Decreases volume, then checks to see if L and R channels are equal.
# If channels are not equal, forces R channel to equal L channel.

amixer sset Master,0 2%-,2%-

L=$(amixer get Master | grep -Eo '[0-9]{1,3}%' | sed -n 1p | tr -d '%')
R=$(amixer get Master | grep -Eo '[0-9]{1,3}%' | sed -n 2p | tr -d '%')

[[ ${L} != ${R} ]] && amixer sset Master,0 ${L}%,${L}%

exit 0
