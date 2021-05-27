#!/bin/sh

## Runs recieving dzen instance for statusbar (listens on fifo)
#	- kills statusbar on exit

fore='#ffffff'
back='#303030'
myfifo=$HOME/tmp/rightstat.fifo
DZEN=/usr/bin/dzen2
title=dzenrightstatus
sigbar=$HOME/usr/share/dzen/bar/sigrightbar.sh

pkill -f "title-name $title "

$DZEN	-title-name "$title" \
	-fn "Source Code Pro-11" \
	-fg "$fore" -bg "$back" \
	-h 26 \
	-x -960 -y 0 \
	-tw 960 \
	-ta r \
	-p \
	-xs 1 \
	-e "button3=exit,exec:$sigbar SIGTERM;\
	;button2=exec:$sigbar" < $myfifo 
