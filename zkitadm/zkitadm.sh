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

# Import settings
source /opt/zerokit/settings.sh

# Include functions
source /opt/zerokit/admintools/zkitadm/functions.sh

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
  check   - Checks if the software can be updated
  update  - Updates NPM packages used by the server
  upgrade - Upgrades service from original git repository
  config  - Opens configuration file for editing
EOF
)
}

function checkupdate {
  main_api="${MAIN_REPO/"github.com"/"api.github.com/repos"}/git/refs/heads/master"
  admin_api="${ADMIN_REPO/"github.com"/"api.github.com/repos"}/git/refs/heads/master"
  
  curl $main_api --max-time 2 2>&1 | grep -s "\"sha\":" | grep -q -v $(git -C /var/www/zerokit rev-parse HEAD 2>&1) && echo "Backend sample can be updated, please use 'zkitadm upgrade' command" ||  if [[ -t 0 || -t 1 ]]; then echo "Backend sample is up-to-date"; fi
  curl $admin_api --max-time 2 2>&1 | grep -s "\"sha\":" | grep -q -v $(git -C /opt/zerokit/admintools rev-parse HEAD 2>&1) && echo "Zkitadm utility can be updated, please use 'zkitadm upgrade' command" ||  if [[ -t 0 || -t 1 ]]; then echo "Zkitadm utility is up-to-date"; fi
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
  git -C "/opt/zerokit/admintools" fetch --all --quiet && git -C "/opt/zerokit/admintools" reset --hard origin/master --quiet
  check "Failed to fetch management scripts from git. Aborting."

  ZkitadmUpgrade="true" "/opt/zerokit/admintools/zkitadm/upgrade.sh"
}

function logo {
  figlet -c -f standard "$LOGO_TEXT" &&  figlet -c -f term "$LOGO_SUBTEXT"
  printf "\n"
  figlet -c -f term "$PROJECT_NAME " && figlet -c -f term "$PROJECT_PAGE "
  printf "\n"
}

function config {
  editor "/etc/zerokit/config.json"
  echo "The service have to be restarted to read new settings. Please use \"zkitadm restart\" command"
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
  npm update --silent >/dev/null 2>&1
  check "Failed to update global packages. Aborting."

  echo -n "Updating server packages..."
  npm update --prefix /var/www/zerokit --silent >/dev/null 2>&1
  check "Failed to update server packages. Aborting."

  echo -n "Restarting app..."
  pm2 start zerokit -s
  check "Failed to restart service. Aborting."

  pm2 status zerokit
}

# Make sure only root can run our script
rootcheck

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
  logo)
    logo
	;;
  config)
    config
	;;
  check)
    checkupdate
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
