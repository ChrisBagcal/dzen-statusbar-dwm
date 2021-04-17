#!/bin/sh

righttags=$HOME/usr/share/dzen/tags/righttags.sh
lefttags=$HOME/usr/share/dzen/tags/lefttags.sh

trap 'exit' INT TERM QUIT
trap 'pkill -f "title-name dzen.*tags ";\
	pkill -f "^/bin/sh.*/.*tags\.sh$";' EXIT

if (which nawk); then
	AWK=$(which nawk)
else
	AWK=$(which awk)
fi

readfifo=/tmp/dwm_tags
writefifo1=$HOME/tmp/fifo.mon1
writefifo2=$HOME/tmp/fifo.mon2

# wait for readfifo to exist
while ! [ -p $readfifo ]; do
	sleep 1
done

[ -p $writefifo1 ] || mkfifo $writefifo1
[ -p $writefifo2 ] || mkfifo $writefifo2

# mulitmonitor stuff
monitors=$(xrandr --listmonitors | $AWK '/Monitors:/ {print $2; exit}')
tag1prev=""
tag2prev=""

tail -f $readfifo | \
while true; do
	# start tags if not running
	(pgrep -f "title-name dzenrighttags " >/dev/null) || $righttags &
	(pgrep -f "title-name dzenlefttags " >/dev/null)  || $lefttags &

	read tagstatus

	# filter tagstatus according to monitor, don't pipe if is content unchanged
	mon=$(echo "$tagstatus" | $AWK '{n=split($0, arr, ":"); print arr[n]}')

	if [ "$mon" = "0" ] && [ "$tagstatus" != "$tag1prev" ]; then
		echo "$tagstatus"  > $writefifo1
		tag1prev="$tagstatus"
	elif [ "$mon" = "1" ] && [ "$tagstatus" != "$tag2prev" ]; then
		echo "$tagstatus" > $writefifo2
		tag2prev="$tagstatus"
	fi

	sleep .01
done
