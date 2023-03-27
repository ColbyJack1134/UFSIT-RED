#!/bin/bash

randomCommands=("cat" "ls" "id" "whoami" "dir" "uname" "ps" "cd" "date" "ip")

function randomStr {
	echo $RANDOM | md5sum | head -c $(( $RANDOM %20 + 5 )); echo;
}

while true; do
	args=""
	END=$(( $RANDOM % 15 + 4))
	
	for i in $(seq 1 $END); do
		args="$args $(randomStr)"
       	done
	
	${randomCommands[ $RANDOM % ${#randomCommands[@]} ]} $args
done


