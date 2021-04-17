#!/bin/sh

bardpid=$(pgrep 'dzenbardaemon')

kill -s USR1 $bardpid
pkill -P $bardpid sleep
