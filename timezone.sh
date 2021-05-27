#!/bin/sh

TIMEZONECMD=$HOME/usr/bin/settimezone.sh

st -g "32x26+1626+30" -n "st-time" -c "st-float" -e $TIMEZONECMD &
