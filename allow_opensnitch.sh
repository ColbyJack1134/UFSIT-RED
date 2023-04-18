#!/bin/bash

for i in /etc/opensnitchd/rules/*; do
	jq '.action = $newVal' --arg newVal 'allow' < $i > $i.tmp
	mv $i.tmp $i
done
