#!/bin/bash

#   -s, --hostname             Set server hostname
#   -e, --email                Set email address
#   -p, --password             Set admin password instead of generating it
#   -m, --mysql-password       Set MySQL password instead of generating it
#   -q, --quota                Enable File System Quota"

# Prevents doing this from other account than root
if [ "x$(id -u)" != 'x0' ]; then
    echo 'Error: this script can only be executed by root'
    exit 1
fi

curl -O https://raw.githubusercontent.com/FastDigitalOceanDroplets/VestaCP/master/vestacp_post.sh
echo
echo
echo "################################################################"
echo "#     https://github.com/FastDigitalOceanDroplets/VestaCP      #"
echo "#                                                              #"
echo "# We will go though the proccess of setting up a full web      #"
echo "# server. It will have web, php, email, ftp, dns, mysql all in #"
echo "# a fantastic easy and smart to use control panel called Vesta.#"
echo "#                                                              #"
echo "# Vesta is free, but you can get paid help at their site.      #"
echo "#                    https://vestacp.com                       #"
echo "################################################################"
echo

while true; do
    read -p "Do you want to change root password for this server? " yn
    case $yn in
        [Yy]* ) passwd; break;;
        [Nn]* ) break;;
        * ) echo "Please answer yes or no.";;
    esac
done

##################################
# Set Vesta domain
echo
echo "Enter a FQDN (full qualified domain name) for your server."
echo "e.g. vm.domain.com (vm from virtual machine for example)."
echo "Is sugested this FQDN to be different from www.domain.com"
echo "This must be defined in your DNSs later"
echo "Digital Ocean offers a free dns service for their clients."
echo

fqdn=""
while [[ -z "$fqdn" ]]
do
    read -p "Enter FQDN: " fqdn
    fqdn=`echo $fqdn | grep -P '(?=^.{1,254}$)(^(?>(?!\d+\.)[a-zA-Z0-9_\-]{1,63}\.?)+(?:[a-zA-Z]{2,})$)'`
done
echo "FQDN $fqdn accepted."
echo

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

##################################
# Get admin's email
while true
do
    read -p "Enter Vesta admin email: " email
    if [[ "$email" =~ ^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$ ]]
    then
        echo "Email address $email is valid."
        echo
        break
    else
        echo "Email address $email is invalid."
        echo
    fi
done

##################################
# change Vesta MySQL password
while true
do
    read -s  -p "Enter MySQL root password: " mysql1
    echo
    read -s  -p "Enter MySQL root password again: " mysql2
    echo
    if  [[ -z "$mysql1" ]] && [[ -z "$mysql2" ]]
    then
        echo "Passwords can't be empty. Try again."
        echo
    else
        if [ $mysql1 != $mysql2 ]
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

# unattended-upgrades
sudo dpkg-reconfigure --priority=low unattended-upgrades
nano /etc/apt/apt.conf.d/50unattended-upgrades

# install vesta with admin's email
curl -O http://vestacp.com/pub/vst-install.sh
bash vst-install.sh -e $email
