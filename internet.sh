#!/bin/sh

  DZEN=dzen2
 title=dzen-popup
  fore="#ffffff"
  back="#303030"
 oncol=green
offcol=red

   dev=wlan0
 state=$(iwctl station $dev show | awk '/State/{ print $2 }')

 internetex=$HOME/usr/share/dzen/internet.sh
  togglenet=$HOME/usr/bin/wm/toggleinternet
 interneton="$togglenet on"
internetoff="$togglenet off"

if [ -z "$curx" ]; then
	curx=$(xdotool getmouselocation)
	curx=${curx%% *}
	curx=${curx##*:}
	export curx
fi

text=""
text=$text"^ca(1, $interneton && $internetex)"
text=$text"On"
text=$text"^ca()"
text=$text" "
text=$text"^ca(1, $internetoff && $internetex)"
text=$text"Off"
text=$text"^ca()"

if [ "$state" = "connected" ]; then
	text=$( echo "$text" | sed "s/On/^fg($oncol)On^fg()/" )
elif [ "$state" = "disconnected" ]; then
	text=$( echo "$text" | sed "s/Off/^fg($offcol)Off^fg()/" )
fi

pkill -f "$title"

echo "$text" | 
	$DZEN -p \
	-fn "FreeMono-13" \
	-title-name "$title" -slave-name "$title" \
	-fg $fore -bg $back \
	-h 26 -w 100 \
	-x $(( $curx - 50 )) -y 30 \
	-ta c -sa c \
	-e "button3=exit"
