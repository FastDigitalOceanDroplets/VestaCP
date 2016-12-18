#!/bin/bash
echo
echo
echo "################################################################"
echo "#     https://github.com/FastDigitalOceanDroplets/VestaCP      #"
echo "#                                                              #"
echo "# We will go though the proccess of setting up a full web      #"
echo "# server. It will have web, php, email, ftp, dns, mysql all in #"
echo "# a fantastic easy and smart to use control panel called Vesta.#"
echo "#                                                              #"
echo "#   Vesta is free, but you can get paid help at their site.    #"
echo "#                    https://vestacp.com                       #"
echo "################################################################"
echo

# Prevents doing this from other account than root
if [ "x$(id -u)" != 'x0' ]; then
    echo 'Error: this script can only be executed by root'
    exit 1
fi

#curl -O https://raw.githubusercontent.com/FastDigitalOceanDroplets/VestaCP/master/vestacp_post.sh

# Creates SWAP on the server
# One of the things that I have lerned is that this kind of servers need swap.
# With these fast SSD disks you gain kind of "pseudo-ram"!!!.
sudo fallocate -l 1024M /swapfile
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
dpkg-reconfigure locales

# Update all your server software
apt-get -y update
apt-get -y upgrade
apt-get -y dist-upgrade
apt-get -y autoremove

# unattended-upgrades
apt-get -y install update-notifier-common
curl -O https://raw.githubusercontent.com/FastDigitalOceanDroplets/VestaCP/master/files/50unattended-upgrades
cat 50unattended-upgrades > /etc/apt/apt.conf.d/50unattended-upgrades
rm 50unattended-upgrades
echo 'APT::Periodic::Update-Package-Lists "1";
APT::Periodic::Unattended-Upgrade "1";' > /etc/apt/apt.conf.d/20auto-upgrades


# remove group admin
delgroup admin

# install vesta with admin's email
curl -O http://vestacp.com/pub/vst-install.sh
bash vst-install.sh

# bash vst-install.sh --nginx yes --apache yes --phpfpm no --vsftpd yes --proftpd no --exim yes --dovecot yes --spamassassin yes --clamav yes --named yes --iptables yes --fail2ban yes --mysql yes --postgresql no --remi no --quota yes --hostname host.domain.xx --email user@domain.xx --password xxx
