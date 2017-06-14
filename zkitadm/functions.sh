#!/bin/bash

# Common functions for VM to became an Azure marketplace image
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

# Checks root permissions
function rootcheck {
  # Make sure only root can run our script
  if [ "$(id -u)" != "0" ]; then
    echo -n "You are not root! "
    fail "This script must be run as root. Aborting."
  fi
}
