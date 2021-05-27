#!/bin/sh

MUSICCMD="mocp --moc-dir $HOME/.config/moc/"
pkill -f "st.*-n st-music"

curx=$(xdotool getmouselocation | cut -d " " -f "1" | tr -d "x:")

st -n "st-music" -c "st-float" -g "80x16+$(( $curx - 300 ))+30" -e $MUSICCMD
