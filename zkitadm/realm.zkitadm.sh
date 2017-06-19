#!/bin/bash

# Script for managing ROS on ZeroKit VMs installed from Azure marketplace
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
# https://github.com/tresorit/ZeroKit-Azure-backend-sample-realm
#
# Licence: BSD 3-Clause License
#
# (C) Copyright 2017 by Tresorit AG.

# Import settings
source /opt/zerokit/settings.sh

# Include functions
source /opt/zerokit/admintools/zkitadm/functions.sh

# Import njspkg
source /opt/zerokit/njspkg.sh

# Prints help screen
function help {
(cat <<EOF
Usage : zkitadm realm <command>

Commands :
  help    - Prints this screen
  status  - Prints hosting process status
  restart - Restarts hosting process
  stop    - Stops service
  start   - Starts service
  check   - Checks whether service can be updated with aptitude package manager
  upgrade - Upgrades service by aptitude package manager
  config  - Opens configuration file for editing
EOF
)
}

function checkupdate {
  apt-get -s upgrade | awk '/^Inst/ { print $2 }' | grep "^realm-object-server-developer$" && echo "Realm Object server can be updated. Please run 'zkitadm realm upgrade' command" || if [[ -t 0 || -t 1 ]]; then echo "Realm object sever is up-to-date"
}

function upgrade {
  echo "This command will upgrage Realm object server with aptitude package manager."
  read -p "Are you sure? " -n 1 -r
  echo ""
  if [[ ! $REPLY =~ ^[YyZz]$ ]]
  then
    exit 1;
  fi

  echo -n "Updating Realm object server..."
  apt-get --only-upgrade install -q -y realm-object-server-developer
  check "Failed to upgrade Realm object server. Aborting."
}

function config {
  editor "/etc/realm/configuration.yml"
  echo "The service has to be restarted to read new settings. Please use \"zkitadm realm restart\" command"
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
    systemctl start realm-object-server
	;;
  stop)
    systemctl stop realm-object-server
	;;
  restart)
    systemctl restart realm-object-server
	;;
  status)
    systemctl status realm-object-server
	;;
  config)
    config
	;;
  check)
    checkupdate
    ;;
  upgrade)
	upgrade
	;;
  *)
	help
    exit 1
	;;
esac
