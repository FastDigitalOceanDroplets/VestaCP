#!/bin/bash
#
# Minimal requirements

# curl -O https://dl.dropboxusercontent.com/u/xxx/Digital_Ocean_Vesta/vesta.sh && bash vesta.sh
if [ "x$(id -u)" != 'x0' ]; then
    echo 'Error: this script can only be executed by root'
    exit 1
fi
# -------------- Creats SWAP
sudo fallocate -l 512M /swapfile
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile
sudo echo "/swapfile   none    swap    sw    0   0" >> /etc/fstab
sudo sysctl vm.swappiness=10
sudo echo "vm.swappiness=10" >> /etc/sysctl.conf
sudo sysctl vm.vfs_cache_pressure=50
sudo echo "vm.vfs_cache_pressure=50" >> /etc/sysctl.conf

# sudo apt-get install ntp # Solo en servidores reales, no en Digital Ocean
sudo timedatectl set-timezone America/Argentina/Buenos_Aires

#curl -O https://dl.dropboxusercontent.com/u/xxx/Digital_Ocean_Vesta/vesta_posti.sh

export LC_ALL=en_US.UTF-8
export LANG="en_US.UTF-8"
export LANGUAGE=en_US.UTF-8
echo 'LC_ALL=en_US.UTF-8' >> /etc/environment
echo 'LANG=en_US.UTF-8' >> /etc/environment
echo 'LANGUAGE=en_US.UTF-8' >> /etc/environment

apt-get update
apt-get upgrade
apt-get dist-upgrade
apt-get autoremove

apt-get install --reinstall language-pack-en
locale-gen
locale-gen en_US.UTF-8
dpkg-reconfigure locales

clear
echo "Cambiamos la clave de root"
passwd root
echo

# email="youremail@gmail.com"
# echo "Instalamos VestaCP con $email como email de admin"
curl -O http://vestacp.com/pub/vst-install.sh
bash vst-install.sh 
# -e $email

# De aca para abajo no se ejecuta nada
# Arreglar el MySQL
service mysql stop && service mysql start && dpkg-reconfigure mysql-server-5.5
