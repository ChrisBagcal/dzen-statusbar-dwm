#!/bin/sh

rightbar=$HOME/usr/share/dzen/bar/statusbarright.sh
leftbar=$HOME/usr/share/dzen/bar/statusbarleft.sh

trap 'exit' INT TERM QUIT
trap 'pkill -f "title-name dzen.*status "' EXIT

# mulitmonitor stuff
monitors=$(xrandr --listmonitors | awk '/Monitors:/ {print $2; exit}')

while true; do
	# start statusbars if not running
	(pgrep -f "title-name dzenrightstatus " >/dev/null) || $rightbar &
	if [ $monitors = "2" ]; then
		(pgrep -f "title-name dzenleftstatus " >/dev/null)  || $leftbar &
	fi

	sleep 10 &
	wait $!
done
