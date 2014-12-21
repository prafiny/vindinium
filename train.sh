#!/bin/bash
if [ $# == 1 ]; then
  rbx client.rb 1jmomh47 training $1;
else
	echo "Usage: ./batch.sh NUMBER_OF_TURNS"
fi

