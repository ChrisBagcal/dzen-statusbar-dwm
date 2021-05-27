#!/bin/sh

die="pkill -f 'title-name dzen-opts'"

eval $die

DZEN=/usr/bin/dzen2
dict=$HOME/usr/share/dzen/dict.sh
fore="#ffffff"
back="#303030"
name="dzen-opts"

export query=\
$(\
	xclip -selection clipboard -o | \
       	head -n1 | \
	sed 's/[^A-Za-z_]//g' \
)

export MOUSEPOS=$(xdotool getmouselocation | cut -d " " -f "1,2" | tr -d "xy:")
export curx=$(echo $MOUSEPOS | cut -d " " -f 1)
export cury=$(echo $MOUSEPOS | cut -d " " -f 2)

opts="Options"

if [ -n "$query" ]; then
       	opts=$opts"\n^ca(1, $dict & $die)Lookup \"$query\"^ca()"
fi

class=$(xprop -id $(xdotool getwindowfocus) | \
	awk '/WM_CLASS/{ n=split($0,arr); gsub(/"/, "", arr[n]); print tolower(arr[n]) }')

if [ "$class" = "st-256color" ]; then
	opts=$opts"\n^ca(1, xdotool key control+shift+c & $die)Copy    Shift+Ctrl+C^ca()"
	opts=$opts"\n^ca(1, xdotool key control+shift+v & $die)Paste   Shift+Ctrl+V^ca()"
else
	opts=$opts"\n^ca(1, xdotool key control+c & $die)Copy    Ctrl+C^ca()"
	opts=$opts"\n^ca(1, xdotool key control+v & $die)Paste   Ctrl+V^ca()"
fi

lines=$(( $(echo "$opts" | wc -l) - 1 ))

echo "$opts" | \
	$DZEN -p -ta c -sa c \
	-title-name $name -slave-name $name \
	-fn "DroidSansMono-11" \
	-bg $back -fg $fore \
	-w 210 -h 26 \
	-ta c -sa c \
	-x $curx -y $cury \
	-l $lines -m \
	-e "button3=exit;\
	;onstart=uncollapse,scrollhome;\
	;leaveslave=exit;\
	;button4=scrollup;\
	;button5=scrolldown"
