#!/bin/bash
if [ $# == 1 ]; then
	for i in `seq 1 $1`; do
		CLASSPATH=./jruby.jar:$CLASSPATH java client 1jmomh47 arena 1;
	done
else
	echo "Usage: ./batch.sh NUMBER_OF_GAMES"
fi
