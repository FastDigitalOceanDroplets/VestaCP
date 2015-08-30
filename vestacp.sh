#!/bin/bash

#   -s, --hostname             Set server hostname
#   -e, --email                Set email address
#   -p, --password             Set admin password instead of generating it
#   -m, --mysql-password       Set MySQL password instead of generating it
#   -q, --quota                Enable File System Quota"


curl -O https://raw.githubusercontent.com/FastDigitalOceanDroplets/VestaCP/master/vestacp_post.sh

# Prevents doing this from other account than root
if [ "x$(id -u)" != 'x0' ]; then
    echo 'Error: this script can only be executed by root'
    exit 1
fi

##################################
# Interactive Part
# change root password

    while true
    do
	read -s  -p "Enter root password: " rootpass1
    	echo
	read -s  -p "Enter root password again: " rootpass2
	echo
	if  [[ -z "$rootpass1" ]] && [[ -z "$rootpass2" ]]
	then
	     echo "Password will not be changed. Both are empty."
	     echo
             break
	else
	    if [ $rootpass1 != $rootpass2 ]
	    then
                echo "Passwords are not identical. Try again."
                echo
 	    else
                echo "root:$rootpass1" | chpasswd
                echo "Password changed."
                echo
                break
            fi
	fi
    done

##################################
# Get admin's email
while true
do
    read -p "Enter Vesta admin email: " email
    echo
    if [[ "$email" =~ ^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$ ]]
    then
        echo "Email address $email is valid."
        break
    else
        echo "Email address $email is invalid."
    fi
done

exit
# Creates SWAP on the server
# One of the things that I have lerned is that this kind of servers need swap.
# These fast SSD disks do this even more dicirable to have.
sudo fallocate -l 512M /swapfile
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile
sudo echo "/swapfile   none    swap    sw    0   0" >> /etc/fstab
sudo sysctl vm.swappiness=10
sudo echo "vm.swappiness=10" >> /etc/sysctl.conf
sudo sysctl vm.vfs_cache_pressure=50
sudo echo "vm.vfs_cache_pressure=50" >> /etc/sysctl.conf

# Change time zone at your new server
dpkg-reconfigure tzdata

# Set the locale on your computer (is not the smartest way, I accept sugestions to do it interactivily)
export LC_ALL=en_US.UTF-8
export LANG="en_US.UTF-8"
export LANGUAGE=en_US.UTF-8
echo 'LC_ALL=en_US.UTF-8' >> /etc/environment
echo 'LANG=en_US.UTF-8' >> /etc/environment
echo 'LANGUAGE=en_US.UTF-8' >> /etc/environment

# Update all your server software
apt-get update
apt-get upgrade
# apt-get dist-upgrade
# apt-get autoremove

# Reconfigure locale
apt-get install --reinstall language-pack-en
locale-gen
locale-gen en_US.UTF-8
dpkg-reconfigure locales

# install vesta with admin's email
curl -O http://vestacp.com/pub/vst-install.sh
bash vst-install.sh -e $email
