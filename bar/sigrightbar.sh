#!/bin/sh

STATUSBAR="/bin/sh.*/statusbarright\.sh"

case $1 in
	"") sig="SIGUSR1" ;; # default
	"internet") sig="SIGRTMIN" ;;
	"volume") sig="SIGRTMIN+1" ;;
	"music") sig="SIGRTMIN+2" ;;
	*) sig="$1" ;;
esac

pkill --signal "$sig" -f "$STATUSBAR"
pkill -P "$(pgrep -f $STATUSBAR)" sleep
