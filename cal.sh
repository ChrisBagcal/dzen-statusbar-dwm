#!/bin/sh

DZEN=dzen2
fore="#ffffff"
back="#303030"
highbg="#ffa07a" # "#800080"
highfg="#202020"

icons="$HOME/Images/bitmaps/"
calex=$HOME/usr/share/dzen/cal.sh

# cur_col, next_col, icon
trans() {
	cur_col=$1
	next_col=$2
	icon=$3

	str=""
	str=$str"^fg($cur_col)^bg($next_col)"
	str=$str"^i($icon)"
	str=$str"^fg()^bg()"
	
	echo $str
}

pkill -f "dzencalender"

opts='m:y:'

args=$(getopt $opts $@ 2>/dev/null)
eval set -- "$args"
unset args

# parse args
while true; do
	case $1 in
		('-m')
			month=$2
			shift 2
		;;
		('-y')
			year=$2
			shift 2
		;;
		('--')
			break
		;;
	esac
done

[ -z "$month" ] && month=$(date +%m)
[ -z "$year" ] && year=$(date +%Y)

if [ $month -lt 1 ]; then
       	month=12
       	year=$(($year - 1))
elif [ $month -gt 12 ]; then
       	month=1
	year=$(($year + 1))
fi

curdate="$(date +'%B %Y' -d $year-$month-1)"

calender=$(cal $month $year | sed -e '/^ *$/d')
calender=$(echo "$calender" | sed \
"s|$curdate|\
^p(-27)\
^ca(1, $calex -m $(($month - 1)) -y $year)\
$(trans "$highbg" $back $icons/fn26/tri/mid_right_tri_stripe.xbm)\
^ca()\
^fg($highfg)^bg($highbg) \
^ca(1, $calex -m $(date +%m) -y $(date +%Y))\
$curdate \
^ca()\
^ca(1, $calex -m $(($month + 1)) -y $year)\
$(trans $highbg $back $icons/fn26/tri/mid_left_tri_stripe.xbm)^bg($back)\
^ca()|")

if [ $month -eq $(date +%m) ] && [ $year -eq $(date +%Y) ]; then # current month
	calender=$(echo "$calender" | \
		sed "s/\($(date +%e)\)/^fg($highfg)^bg($highbg)\1^fg()^bg()/")
fi

lines=$(($(echo "$calender" | wc -l) - 1))

echo "$calender" | 
	$DZEN -p \
	-fn "DejaVuSansMono" \
	-title-name "dzencalender" \
	-fg $fore -bg $back \
	-x 1465 -y 30 \
	-h 26 -w 226 \
	-ta c -sa c \
	-l $lines \
	-e "onstart=uncollapse;
	;button4=exec:$calex -m $(($month + 1)) -y $year;
	;button5=exec:$calex -m $(($month - 1)) -y $year;
	;button3=exit"
