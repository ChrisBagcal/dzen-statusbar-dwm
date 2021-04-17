#!/bin/sh

fore='#ffffff'
back='#303030'
col1="#303030"
col2="#404040"
col3="#505050"
special="#44aabb"

if (which nawk); then
	AWK=$(which nawk)
else
	AWK=$(which awk)
fi

DZEN=dzen2

readfifo=$HOME/tmp/fifo.mon2
tagsexy=$HOME/usr/share/dzen/tags/tagrightsexy.awk

pkill -f "title-name dzenrighttags"

# wait for fifo to exist
while ! [ -p $readfifo ]; do
	sleep 1
done

tail -f $readfifo | \
while true; do
	read tagstatus

	bartxt=""
	bartxt=$bartxt"$(echo $tagstatus | $AWK -f $tagsexy)"

	echo "$bartxt"

	sleep .01

done | $DZEN \
	-title-name 'dzenrighttags' \
	-fn "Source Code Pro" \
	-fg "$fore" -bg "$back" \
	-h 26 \
	-x 960 -y 0 \
	-w 960 \
	-ta r \
	-p \
	-xs 2 \
	-e 'button3=exit'
