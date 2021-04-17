#!/bin/sh

fore='#ffffff'
back='#303030'
col1="#303030"
col2="#505050"
col3="#707070"
special="#44aabb" #"#800080"
transition="fn26/tri/mid_right_tri_stripe.xbm"

DZEN=dzen2
calex=$HOME/usr/share/dzen/cal.sh

icons="$HOME/Images/bitmaps"
nohttp="/run/nohttp"

pkill -f dzenrightstatus

while true; do
	bartxt=""

	# username
	bartxt=$bartxt"^fg($special)^bg($col1) ^i($icons/$transition)"
	bartxt=$bartxt"^fg($fg)^bg($special) $(whoami)"
	bartxt=$bartxt"^fg($col1)^bg($special) ^i($icons/$transition)"
	bartxt=$bartxt"^p()^fg($fore)^bg($col1)"

	#leftvol=$(amixer get 'Master',0 | grep 'Front Left:' | \
	#       	awk '{print $5 $6}' | sed -e 's/\[//' -e 's/%\]//')
	#rightvol=$(amixer get 'Master',0 | grep 'Front Right:' | \
	#       	awk '{print $5 $6}' | sed -e 's/\[//' -e 's/%\]//')

	#bartxt=$bartxt" ^fg(#000000)^i($icons/vol.xbm)^fg()"
	#bartxt=$bartxt" $leftvol-$rightvol"

	#bartxt=$bartxt"^fg($col1)^bg($col3) ^i($icons/$transition)"
	#bartxt=$bartxt"^p()^fg($fore)^bg($col1)"

	# http
	bartxt=$bartxt"^fg($col1)0" # spacing
	if [ -f $nohttp ]; then # off
		bartxt=$bartxt" ^fg(grey)"
	else # on
		bartxt=$bartxt" ^fg(green)"
	fi
	bartxt=$bartxt"^p(;1)^fn(FreeMono-12)http://^fn()^p()"
	bartxt=$bartxt"^fg($col1)0" # spacing

	bartxt=$bartxt"^fg(#696969)^i($icons/fn26/line.xbm)"
	bartxt=$bartxt"^fg($fore)^bg($col1)"

	# wifi
	if [ -z "$(ip link show wlan0 && ip link show eno1 up)" ] || \
		!(ping -q -c 1 -W 5 opendns.com >/dev/null 2>&1); then
		bartxt=$bartxt" ^fg(grey)"

		bartxt=$bartxt"^fn(FreeMono-12)0.0.0.0^fn()"
	else
		bartxt=$bartxt" ^fg(green)"
		ipv4=$(ip address show wlan0 | grep inet | awk '{printf "%s", $2 }')
		bartxt=$bartxt"^fn(FreeMono-12)^fg(green)$ipv4^fn()"
	fi
	
	bartxt=$bartxt"^fg($col2)^bg($col1) ^i($icons/$transition)"

	# date & time
	bartxt=$bartxt"^p()^fg($fore)^bg($col2)"
	bartxt=$bartxt"^ca(1, $calex -m $(date +%m) -y $(date +%Y))\
		^fg(#ffa07a)^i($icons/fn26/cal.xbm)^ca()^fg()"
	bartxt=$bartxt" $(date +'%a - %b %d, %Y')"

	bartxt=$bartxt"^fg($col3)^bg($col2) ^i($icons/$transition)"
	bartxt=$bartxt"^p()^fg($fore)^bg($col3)"
	bartxt=$bartxt" ^fg(#f0e68c)^i($icons/fn26/hourglass2.xbm)^fg()"
	
	bartxt=$bartxt" $(date +'%Z %I:%M %p')"
	bartxt=$bartxt"^fg($col3)0" # spacing

	echo $bartxt
	sleep 1

done | $DZEN \
	-title-name 'dzenrightstatus' \
	-fn "Source Code Pro" \
	-fg "$fore" -bg "$back" \
	-h 26 \
	-x -960 \
	-w 960 \
	-ta r \
	-p \
	-xs 1 \
	-e 'button3=exit'
