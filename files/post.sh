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


# Get Vestas Installed version
installedversion=`apt-cache policy vesta | grep "Installed"`
installedversion=$(trim "$installedversion")
echo "$installedversion"
if [ "$installedversion" == "Installed: 0.9.8-17" ]; then
	echo "Applying: 0.9.8-17 Patches"
	#patch to fix mysql md5 passwords missing on restore
	curl https://raw.githubusercontent.com/serghey-rodin/vesta/04d617d756656829fa6c6a0920ca2aeea84f8461/func/db.sh > /usr/local/vesta/func/db.sh
	curl https://raw.githubusercontent.com/serghey-rodin/vesta/04d617d756656829fa6c6a0920ca2aeea84f8461/func/rebuild.sh > /usr/local/vesta/func/rebuild.sh
	reboot
fi


# Adds HTTPS certificate from LetsEncrypt to VestaCP control panel at the host name site on the admin user

hostname=`hostname`
v-add-letsencrypt-user admin
v-add-letsencrypt-domain admin $hostname
echo '#!/bin/bash

cert_src="/home/admin/conf/web/ssl.$hostname.pem"
key_src="/home/admin/conf/web/ssl.$hostname.key"
cert_dst="/usr/local/vesta/ssl/certificate.crt"
key_dst="/usr/local/vesta/ssl/certificate.key"

if ! cmp -s $cert_dst $cert_src
then
        # Copy Certificate
        cp $cert_src $cert_dst

        # Copy Keyfile
        cp $key_src $key_dst

        # Change Permission
        chown root:mail $cert_dst
        chown root:mail $key_dst

        # Restart Services
        service vesta restart &> /dev/null
        service exim4 restart &> /dev/null
fi
' >/etc/cron.daily/vesta_ssl
chmod +x /etc/cron.daily/vesta_ssl
/etc/cron.daily/vesta_ssl
