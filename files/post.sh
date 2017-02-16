#!/bin/bash

# Change admin password (to do) /usr/local/vesta/bin/v-change-user-password admin 
##################################
# change Vesta admin password
while true
do
 	read -s  -p "Enter VestaCP admin password: " adminpass1
 	echo
 	read -s  -p "Enter VestaCP admin password again: " adminpass2
	echo
	if  [[ -z "$adminpass1" ]] && [[ -z "$adminpass2" ]]
	then
		echo "Passwords can't be empty. Try again."
		echo
	else
		if [ $adminpass1 != $adminpass2 ]
		then
			echo "Passwords are not identical. Try again."
			echo
 		else
 			echo "Password accepted."
 			echo
			break
		fi
	fi
done
/usr/local/vesta/bin/v-change-user-password admin $adminpass1


# Get Vestas Installed version
installedversion=`apt-cache policy vesta | grep "Installed"`
echo "$installedversion"
if [ "$installedversion" == "  Installed: 0.9.8-17" ]; then
	echo "Applying: 0.9.8-17"
	#patch to fix mysql md5 passwords missing on restore
	curl https://raw.githubusercontent.com/serghey-rodin/vesta/04d617d756656829fa6c6a0920ca2aeea84f8461/func/db.sh > /usr/local/vesta/func/db.sh
	curl https://raw.githubusercontent.com/serghey-rodin/vesta/04d617d756656829fa6c6a0920ca2aeea84f8461/func/rebuild.sh > /usr/local/vesta/func/rebuild.sh
	reboot
fi
