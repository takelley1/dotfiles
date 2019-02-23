#! /bin/bash

brightFolder="/sys/class/backlight/intel_backlight/"
stepSize=250
currentbrigth=`cat $brightFolder"brightness"`
