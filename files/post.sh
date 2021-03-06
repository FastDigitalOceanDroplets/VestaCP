#!/bin/bash

trim() {
  local s2 s="$*"
  # note: the brackets in each of the following two lines contain one space
  # and one tab
  until s2="${s#[   ]}"; [ "$s2" = "$s" ]; do s="$s2"; done
  until s2="${s%[   ]}"; [ "$s2" = "$s" ]; do s="$s2"; done
  echo "$s"
  # mystring="   here     is something    "
  # mystring=$(trim "$mystring")
}

# Change admin password (to do) /usr/local/vesta/bin/v-change-user-password admin 
##################################
# change Vesta admin password
while true
do
 	read -s  -p "Enter a new VestaCP admin password: " adminpass1
 	echo
 	read -s  -p "Enter the new VestaCP admin password again: " adminpass2
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


# Get Vesta's Installed version
installedversion=`apt-cache policy vesta | grep "Installed"`
installedversion=$(trim "$installedversion")
echo "$installedversion"
if [ "$installedversion" == "Installed: 0.9.8-17" ]; then
	echo "Applying: 0.9.8-17 Patches"
	#patch to fix mysql md5 passwords missing on restore
	curl https://raw.githubusercontent.com/serghey-rodin/vesta/04d617d756656829fa6c6a0920ca2aeea84f8461/func/db.sh > /usr/local/vesta/func/db.sh
	curl https://raw.githubusercontent.com/serghey-rodin/vesta/04d617d756656829fa6c6a0920ca2aeea84f8461/func/rebuild.sh > /usr/local/vesta/func/rebuild.sh
	doReboot=true
fi

# Force https/SSL on a domain adding template
cd /usr/local/vesta/data/templates/web
wget http://c.vestacp.com/0.9.8/rhel/force-https/nginx.tar.gz
tar -xzvf nginx.tar.gz
rm -f nginx.tar.gz

# Added v-search command

curl -H 'Cache-Control: no-cache' https://raw.githubusercontent.com/FastDigitalOceanDroplets/VestaCP/master/files/v-search-command > /usr/local/vesta/bin/v-search-command
chmod 770 /usr/local/vesta/bin/v-search-command

# Adds HTTPS certificate from LetsEncrypt to VestaCP control panel at the host name site on the admin user

	# force creation of pipe because on ocational times is missing.
	touch /usr/local/vesta/data/queue/letsencrypt.pipe
	chmod 750 /usr/local/vesta/data/queue/letsencrypt.pipe

hostname=`hostname`
v-add-letsencrypt-user admin
v-add-letsencrypt-domain admin $hostname
while [ ! -f "/home/admin/conf/web/ssl."$hostname".pem" ]; do sleep 1;echo; done
while [ ! -f "/home/admin/conf/web/ssl."$hostname".key" ]; do sleep 1;echo; done
curl -H 'Cache-Control: no-cache' https://raw.githubusercontent.com/FastDigitalOceanDroplets/VestaCP/master/files/vesta_ssl > /etc/cron.daily/vesta_ssl
sed -i 's/0DOMAIN0/'$hostname'/gi' /etc/cron.daily/vesta_ssl
chmod +x /etc/cron.daily/vesta_ssl
/etc/cron.daily/vesta_ssl

if [ "$doReboot" = true ] ; then
	echo "Reboot in progress..."
	reboot
fi
exit 
