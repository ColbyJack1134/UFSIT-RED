#!/bin/bash

# Call 'w' and filter out lines containing '10.8.0.10'
wOut=$(/bin/who | grep -v '10.8.0.10')

# Read the filtered file line by line and update pts numbers accordingly
counter=1
while IFS= read -r line; do
  if [[ $line =~ pts/ ]]; then
    old_pts=$(echo "$line" | grep -o -E "pts\/[0-9]+" | grep -o -E "[0-9]+") 
    new_pts="$counter"
    
    # Check if old_pts has two digits and new_pts has one, then add a space to new_pts
    if [[ ${#old_pts} -gt ${#new_pts} ]]; then
      new_pts="$new_pts "
    fi

    line=$(echo "$line" | sed -E "s/pts\/[0-9]+/pts\/$new_pts/")
    counter=$((counter + 1))
  fi
  echo "$line"
done <<< $wOut
