#!/bin/bash

# Script for upgrading ZeroKit VMs installed from Azure marketplace
# 
# Prerequisites:
# Installed and working git and npm. (On a VM purchased from Azure marketplace)
#
# Target folders:
# web app    /var/www/zerokit
# config     /etc/zerokit
# management /opt/zerokit
#
# Project page:
# https://github.com/tresorit/ZeroKit-Azure-marketplace-VM
# https://github.com/tresorit/ZeroKit-Azure-backend-sample
#
# Licence: BSD 3-Clause License
#
# (C) Copyright 2017 by Tresorit AG.

# Import settings
source /opt/zerokit/settings.sh

# Include functions
source /opt/zerokit/admintools/zkitadm/functions.sh

#
# Execute upgrade
#  

# Make sure only root can run our script
rootcheck

# Check if script was called from zkitadm
if [ -z ${ZkitadmUpgrade+x} ] || [ ! "$ZkitadmUpgrade" == "true" ]; then
  echo -n "Validating upgrade..."
  fail "This script should not invoked directly. Please use zkitadm upgrade command instead."
fi

echo -n "Stopping service..."

pm2 stop zerokit -s
check "Failed to stop service. Aborting."
  
echo -n "Updating global NPM packages..."
npm update --silent -g >/dev/null 2>&1
check "Failed to update global packages. Aborting."

echo -n "Fetching new version from repository..."
git -C /var/www/zerokit fetch --all --quiet && git -C /var/www/zerokit reset --hard origin/master --quiet
check "Failed to fetch new version from git. Aborting."

echo -n "Updating server packages (1/2)..."
rm -rf "/var/www/zerokit/node_modules" 2>&1
check "Failed to update server packages (1/2). Aborting."

echo -n "Updating server packages (2/2)..."
npm install --prefix /var/www/zerokit --silent >/dev/null 2>&1
check "Failed to update server packages (2/2). Aborting."

echo -n "Restarting app..."
pm2 start zerokit -s
check "Failed to restart service. Aborting."

pm2 status zerokit