#!/bin/bash

# Change admin password (to do) /usr/local/vesta/bin/v-change-user-password admin 

# Get Vestas Installed version
installedversion=`apt-cache policy vesta | grep "Installed"`

if [ "$installedversion" == "  Installed: 0.9.8-17" ]; then

#patch to fix mysql md5 passwords missing on restore
curl https://raw.githubusercontent.com/serghey-rodin/vesta/04d617d756656829fa6c6a0920ca2aeea84f8461/func/db.sh > /usr/local/vesta/func/db.sh
curl https://raw.githubusercontent.com/serghey-rodin/vesta/04d617d756656829fa6c6a0920ca2aeea84f8461/func/rebuild.sh > /usr/local/vesta/func/rebuild.sh
reboot

fi



