#!/bin/bash

# NodeJS package management implementation with NPM
# 
# Prerequisites:
# Installed and working npm. (On a VM purchased from Azure marketplace)
#
# Project page:
# https://github.com/tresorit/ZeroKit-Azure-marketplace-VM
# https://github.com/tresorit/ZeroKit-Azure-backend-sample
#
# Licence: BSD 3-Clause License
#
# (C) Copyright 2017 by Tresorit AG.

function njspkg-install-app {
	npm install --prefix $1 --silent >/dev/null 2>&1
}

function njspkg-install-package {
	npm install $2 --prefix $1 --silent >/dev/null 2>&1
}

function njspkg-update-app {
	npm update --prefix /var/www/zerokit --silent >/dev/null 2>&1
}

function njspkg-install-global {
	npm install $1 --silent >/dev/null 2>&1
}

function njspkg-update-global {
	npm update -g --silent >/dev/null 2>&1
}
