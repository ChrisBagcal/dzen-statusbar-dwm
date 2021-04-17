#!/bin/sh

fore='#ffffff'
back='#303030'
col1="#303030"
col2="#505050"
col3="#707070"
special="#44aabb" #"#800080"
transition="fn26/tri/mid_left_tri_stripe.xbm"
DZEN=dzen2

icons="$HOME/Images/bitmaps"

pkill -f dzenleftstatus

while true; do
	bartxt=""

	# date
	bartxt=$bartxt"^fg($fore)^bg($col3)"
	bartxt=$bartxt" ^fg(#f0e68c)^i($icons/fn26/hourglass2.xbm)^fg()"
	bartxt=$bartxt" $(date +'%Z %I:%M %p') "

	bartxt=$bartxt"^fg($col3)^bg($special)^i($icons/$transition)"
	bartxt=$bartxt"^p()^fg($fore)^bg($col3)"

	# username
	bartxt=$bartxt"^fg($fg)^bg($special)$(whoami) "
	bartxt=$bartxt"^fg($special)^bg($col1)^i($icons/$transition)"
	bartxt=$bartxt"^p()^fg($fore)^bg($col1)"

	echo $bartxt
	sleep 1

done | $DZEN \
	-title-name 'dzenleftstatus' \
	-fn "Source Code Pro" \
	-fg "$fore" -bg "$back" \
	-h 26 \
	-x 0 \
	-w 960 \
	-ta l \
	-p \
	-xs 2 \
	-e 'button3=exit'
