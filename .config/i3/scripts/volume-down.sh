#!/bin/bash

# decreases volume, then checks to see if both L and R channels are in sync
# if channels are not in sync, forces R channel to equal L channel

amixer sset Master,0 2%-,2%-

L=$(amixer get Master | grep -o '[0-9]*%' | sed -n 1p | tr -d '%')
R=$(amixer get Master | grep -o '[0-9]*%' | sed -n 2p | tr -d '%')

if [ $L != $R ]
then
	amixer sset Master,0 $L%,$L%
fi

exit 0
