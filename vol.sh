#!/bin/sh

VOLCMD="pulsemixer"
pkill -f "st.*-n st-vol"

st -n "st-vol" -c "st-float" -g 'x12+1000+30' -e $VOLCMD
