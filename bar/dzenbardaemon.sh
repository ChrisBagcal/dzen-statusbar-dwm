#!/bin/sh

# BAR OFF -> kill daemons, tail -f the dwm tag socket

readfifo=/tmp/dwm_tags
tagdaemon=$HOME/usr/share/dzen/tags/tagdaemon.sh
statusdaemon=$HOME/usr/share/dzen/bar/statusdaemon.sh
hidden=false

# SIGUSR1 toggles hidden variable
trap	'if [ "$hidden" = "false" ]; then\
		hidden=true;\
	else\
		hidden=false;\
	fi;' USR1

# wait for fifo to exist
while ! [ -p $readfifo ]; do
	sleep 1
done

# start/kill daemons
while true; do
	tailpid=$(pgrep -f "tail -f $readfifo --pid=$$")

	if [ "$hidden" = "true" ]; then
		pkill --signal SIGTERM -f "/bin/sh.*/tagdaemon\.sh"
		pkill --signal SIGTERM -f "/bin/sh.*/statusdaemon\.sh"
		[ -z "$tailpid" ] && (tail -f $readfifo --pid=$$ &)
	else
		[ -n "$tailpid" ] && kill $tailpid

		# start tag/status-daemons if not running
		(pgrep -f "/bin/sh.*/tagdaemon\.sh")    || $tagdaemon &
		(pgrep -f "/bin/sh.*/statusdaemon\.sh") || $statusdaemon &
	fi
	
	sleep 60
done
