#!/bin/sh

query=\
$(\
	xclip -selection clipboard -o | \
       	head -n1 | \
	sed 's/[^A-Za-z_]//g' \
)

[ -z "$query" ] && exit 1

DICT=sdcv
DZEN=/usr/bin/dzen2
fore="#ffffff"
back="#303030"
  hl="#44aabb"
name="dzen-popup"

[ -z "$MOUSEPOS" ] && MOUSEPOS=$(xdotool getmouselocation | cut -d " " -f "1,2" | tr -d "xy:")
[ -z "$curx" ]     && curx=$(echo $MOUSEPOS | cut -d " " -f 1)
[ -z "$cury" ]     && cury=$(echo $MOUSEPOS | cut -d " " -f 2)

$DICT -n "$query" | \
	sed -e "s/$query/^fg($hl)$query^fg()/" | \
	\
	$DZEN -p -ta c -sa c \
	-title-name $name -slave-name $name \
	-fn "DroidSansMono-11" \
	-bg $back -fg $fore \
	-w 700 -h 26 \
	-ta c -sa l \
	-xs 1 -x $curx -y $cury \
	-l 20 \
	-e "button3=exit;\
	;onstart=uncollapse,scrollhome;\
	;button1=exit;\
	;button4=scrollup;\
	;button5=scrolldown"
