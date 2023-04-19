#!/bin/bash

# List of benign commands
BENIGN_COMMANDS=("ls" "pwd" "whoami" "date" "uname -a" "id" "uptime" "ps" "top" "vim")

# Get the 'w' command output
W_OUTPUT=$(/usr/bin/w)

# Process each line of the 'w' command output
while IFS= read -r line; do
  if [[ $line =~ ([0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}) ]]; then
    # Generate a random last part for the IP address
    RANDOM_IP_PART=$((RANDOM % 89 + 10))
    
    # Replace the last part of the IP address with the generated random part
    NEW_LINE=${line/$BASH_REMATCH/$(echo ${BASH_REMATCH%.*}.$RANDOM_IP_PART)}
    
    # Choose a random benign command from the list
    RANDOM_COMMAND=${BENIGN_COMMANDS[$RANDOM % ${#BENIGN_COMMANDS[@]}]}
    
    # NEW_LINE=$(echo "$NEW_LINE" | awk -v OFS='\t' -v cmd="$RANDOM_COMMAND " '{$(NF-1)=$1; $NF=cmd; print}')
    NEW_LINE=$(echo "$NEW_LINE" | sed "s/\S\+ *$/${RANDOM_COMMAND}/")
  else
    NEW_LINE=$line
  fi

  # Print the processed line
  echo "$NEW_LINE"
done <<< "$W_OUTPUT"

