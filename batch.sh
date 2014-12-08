#!/bin/bash
if [ -f mon_fichier ]; then
	for i in `seq 1 $1`; do
		jruby client.rb 1jmomh47 arena 1;
	done
else
	echo "Usage: ./batch.sh NUMBER_OF_GAMES"
fi
