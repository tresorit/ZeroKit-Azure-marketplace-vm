#!/bin/bash

# This will prepare and deprovision a VM to became an Azure marketplace image
# 
# Prerequisites:
# Must be run on an Azure VM
# Ubuntu 16.4<
#
# Project page:
# https://github.com/tresorit/ZeroKit-Azure-marketplace-vm
#
# Licence: BSD 3-Clause License
#
# (C) Copyright 2017 by Tresorit AG.

# Check if baseurl is set
if [ -z ${BASEURL+x} ]; then
  echo 'Usage: export BASEURL="<url-of-the-repository>" && curl -sL "$BASEURL/vmprepare/prepare.sh" | sudo -E bash -'
  exit 1
fi

# Make sure only root can run our script
if [ "$(id -u)" != "0" ]; then
   echo "This script must be run as root. Aborting." 1>&2
   exit 1
fi

# Load external settings file
source <(curl -sL "$BASEURL/vmprepare/default.settings.sh")

# Update
apt update -y 
apt upgrade -y 

# Install nodejs
curl -sL https://deb.nodesource.com/setup_7.x | bash -
apt install -y nodejs

# Install YARN
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" > /etc/apt/sources.list.d/yarn.list
apt update
apt install -y yarn

# Install Nginx
apt install -y nginx
systemctl enable nginx
systemctl start nginx

# Install git
apt install -y git

# Install lsb-release, figlet to enable ASCII art and update-motd software
apt install -y lsb-release figlet update-motd

# Install mongo
apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 0C49F3730359A14518585931BC711F9BA15703C6
echo "deb [ arch=amd64,arm64 ] http://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.4 multiverse" >> /etc/apt/sources.list.d/mongodb-org-3.4.list
apt update
apt install -y mongodb-org
systemctl start mongod
systemctl enable mongod

# Setup Iptables
ufw allow 'Nginx HTTP'
ufw allow 'OpenSSH'
ufw --force enable

# Pull repository for management utils
mkdir -p /opt/zerokit/admintools
git clone https://github.com/tresorit/ZeroKit-Azure-marketplace-vm /opt/zerokit/admintools

ln -s /opt/zerokit/admintools/zkitadm/zkitadm.sh /usr/bin/zkitadm
ln -s /opt/zerokit/admintools/vmprepare/default.settings.sh /opt/zerokit/settings.sh
ln -s /opt/zerokit/admintools/vmprepare/yarn.njspkg.sh /opt/zerokit/njspkg.sh

# Load njspkg
source /opt/zerokit/njspkg.sh

# Pull zeroKit sample backend
mkdir -p /var/www/zerokit
git clone $MAIN_REPO /var/www/zerokit
cd /var/www/zerokit
njspkg-install-app /var/www/zerokit

# Link config file
mkdir -p /etc/zerokit
ln -s /var/www/zerokit/config.json /etc/zerokit/config.json

# Copy default settings from pulled repo
cat /opt/zerokit/admintools/.config/zerokit/config.json > /etc/zerokit/config.json
cat /opt/zerokit/admintools/.config/nginx/default > /etc/nginx/sites-enabled/default

# Restart services
systemctl restart nginx

# Install PM2
njspkg-install-global pm2@latest
pm2 start /var/www/zerokit/bin/www --name zerokit
pm2 startup
pm2 save

# Setup MOTD generator
rm -rf /etc/update-motd.d/*
ln -s /opt/zerokit/admintools/.config/motd/* /etc/update-motd.d/
rm -f /etc/motd.dynamic

# Deprovision VM
waagent -deprovision+user -force
