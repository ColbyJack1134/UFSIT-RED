#!/bin/bash
#TODO vim info
#Get all home directories from /etc/passwd
while read -r line; do
	dir=$(echo $line | cut -d ':' -f 6)
	for i in "$dir/."*"_history"; do
		if [ "$i" != "$dir/.*_history" ]; then
			ln -sf /dev/null $i
		fi
	done
done < /etc/passwd
