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

# Make sure only root can run our script
if [ "$(id -u)" != "0" ]; then
   echo "This script must be run as root. Aborting." 1>&2
   sudo su
fi

# Update
apt update
apt upgrade

# Install nodejs
curl -sL https://deb.nodesource.com/setup_7.x | sudo -E bash -
apt install -y nodejs

# Install Nginx
apt install nginx

# Install git
apt install git

# Install lsb-release 
apt install lsb-release

# Install figlet to enable ASCII art
apt install figlet

# Install update-motd software
apt install update-motd

# Install mongo
apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 0C49F3730359A14518585931BC711F9BA15703C6
echo "deb [ arch=amd64,arm64 ] http://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.4 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-3.4.list
apt update
apt install mongodb-org
systemctl start mongod
systemctl enable mongod

# Setup Iptables
ufw allow 'Nginx HTTP'
ufw allow 'OpenSSH'
ufw enable

# Pull zeroKit sample backend
mkdir /var/www/zerokit
git clone https://github.com/tresorit/ZeroKit-NodeJs-backend-sample.git /var/www/zerokit
cd /var/www/zerokit
npm install

# Link config file
mkdir /etc/zerokit
ln -s /var/www/zerokit/config.json /etc/zerokit/config.json

# Pull repository for management utils
mkdir /opt/zerokit
git clone https://github.com/tresorit/ZeroKit-Azure-marketplace-vm /opt/zerokit
ln -s /opt/zerokit/zkitadm/zkitadm.sh /usr/bin/zkitadm

# Copy default settings from pulled repo
cat /opt/zerokit/.config/zerokit/config.json > /var/www/zerokit/config.json
cat /opt/zerokit/.config/nginx/default > /etc/nginx/sites-enabled/default

# Restart services
systemctl restart nginx

# Install PM2
npm install pm2@latest -g
pm2 start /var/www/zerokit/bin/www --name zerokit
pm2 startup
pm2 save

# Setup MOTD generator
rm -r /etc/update-motd.d/
mkdir /etc/update-motd.d/
ls -n /opt/zerokit/.config/motd/* /etc/update-motd.d/
rm /etc/motd.dynamic

# Deprovision VM
waagent -deprovision+user -force
