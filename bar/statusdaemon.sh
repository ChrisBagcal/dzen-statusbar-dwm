#!/bin/sh

## Starts right and left statusbar scripts, 
#	- restarts them if they stop
#	- stops them on exit

trap 'exit' INT TERM QUIT
trap 'pkill -f "title-name dzen.*status ";\
	pkill -f "/bin/sh.*/statusbarright\.sh"' EXIT

rightbar=$HOME/usr/share/dzen/bar/statusbarright.sh
leftbar=$HOME/usr/share/dzen/bar/statusbarleft.sh

# mulitmonitor stuff
monitors=$(xrandr --listmonitors | awk '/Monitors:/ { print $2; exit }')

while true; do
	# start statusbars if not running
	(pgrep -f "/bin/sh.*/statusbarright\.sh" >/dev/null || $rightbar &)
	[ $monitors = "2" ] && (pgrep -f "/bin/sh.*/statusbarleft\.sh" >/dev/null || $leftbar &)

	sleep 10 &
	wait $!
done
