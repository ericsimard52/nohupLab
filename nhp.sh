#!/bin/bash

sl=3
pass=0
passLimit=10
logFile=/tmp/nhp.log
function rec {
    echo "I have received a SIGHUP signal, I quit normaly." | tee $logFile
    exit 0
}
## This will call function rec if we receive any of the listed signals.
trap rec SIGHUP
function runLoop {
    while [ true ]; do
        ## We sleep for $sl
        sleep $sl
        echo "This is pass: $pass"
        if [ $pass -eq $passLimit ]; then
	    echo "Pass limit reached, quitting normally."  | tee $logFile
	    exit 0
	fi
        ((pass++))
    done
}
echo ""
echo "My process ID is $$"
echo "My parent process ID is $PPID"
case $(ps -o stat= -p $$) in
    *+*)
	echo "I don't think I am a forked process"
	echo "To fork the script call it like this: ./nhp.sh &"
	echo "Use the following command in another terminal to send the SIGHUP signal:"
	echo "kill -s SIGHUP $$"
	;;
    *)
	echo "I think this is a forked process"
	echo "Use the following command to send a SIGHUP signal:"
	echo "kill -s SIGHUP $$"
	;;
esac
runLoop

