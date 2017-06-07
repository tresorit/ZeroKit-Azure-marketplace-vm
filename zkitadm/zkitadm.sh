#!/bin/bash

# Script for managing ZeroKit VMs installed from Azure marketplace
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

# Defining colors
RED='\033[0;31m'
NC='\033[0m'
GREEN='\033[0;32m'

# Function definitions

# Prints fail message and exists
function fail {
  printf "[${RED}FAIL${NC}]\n" 1>&2
  if [ $# -gt 0 ]; then
    echo $1 1>&2
  fi
  exit 1
}

# Prints ok message and exists
function success {
  printf "[${GREEN}OK${NC}]\n" 1>&2
  if [ $# -gt 0 ]; then
    echo $1 1>&2
  fi
}

# Checks return code and fails or succeeds
function check {
  if [ $? -ne 0 ]; then
    fail $1
  else
    success
  fi
}

# Prints help screen
function help {
(cat <<EOF
Usage : zkitadm command

Commands :
  help    - Prints this screen
  status  - Prints hosting process status
  restart - Restarts hosting process
  stop    - Stops service
  start   - Starts service
  update  - Updates NPM packages used by the server
  upgrade - Upgrades service from original git repository
  config  - Opens configuration file for editing
EOF
)
}

function upgrade {
  echo "This command will upgrage ZeroKit sample app backend from central git repository."
  read -p "Are you sure? " -n 1 -r
  echo ""
  if [[ ! $REPLY =~ ^[YyZz]$ ]]
  then
    exit 1;
  fi

  echo -n "Updating management scripts from repository..."
  git -C /opt/zerokit fetch --all --quiet && git -C /opt/zerokit reset --hard origin/master --quiet
  check "Failed to fetch management scripts from git. Aborting."

  ZkitadmUpgrade="true" /opt/zerokit/zkitadm/upgrade.sh
}

function update {
  echo "This command will update NPM packages and pm2 process manager used by ZeroKit sample app backend."
  read -p "Are you sure? " -n 1 -r
  echo ""
  if [[ ! $REPLY =~ ^[YyZz]$ ]]
  then
    exit 1;
  fi

  echo -n "Stopping service..."

  pm2 stop zerokit -s
  check "Failed to stop service. Aborting."

  echo -n "Updating global NPM packages..."
  npm update --silent -g  >/dev/null 2>&1
  check "Failed to update global packages. Aborting."

  echo -n "Updating server packages..."
  npm update --prefix /var/www/zerokit/ --silent >/dev/null 2>&1
  check "Failed to update server packages. Aborting."

  echo -n "Restarting app..."
  pm2 start zerokit -s
  check "Failed to restart service. Aborting."

  pm2 status zerokit
}

# Make sure only root can run our script
if [ "$(id -u)" != "0" ]; then
   fail "This script must be run as root. Aborting."
fi

# Check command line arg count
if [ $# -lt 1 ]
then
    help
    exit 1
fi

case "$1" in
  help)
    help
	;;
  start)
    pm2 start zerokit
	;;
  stop)
    pm2 stop zerokit
	;;
  restart)
    pm2 restart zerokit
	;;
  status)
    pm2 status zerokit
	;;
  logs)
    pm2 logs zerokit
	;;
  config)
    editor /etc/zerokit/config.json
	echo "The service have to be restarted to read new settings. Please use \"zkitadm restart\" command"
	;;
  update)
	update
	;;
  upgrade)
	upgrade
	;;
  *)
	help
    exit 1
	;;
esac
