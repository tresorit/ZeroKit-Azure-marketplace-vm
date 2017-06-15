#!/bin/bash

# NodeJS package management implementation with YARN
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
	old_dir=$(pwd)
	cd $1
	yarn install --silent >/dev/null 2>&1
	ret_val=$?
	cd $old_dir
	return $ret_val
}

function njspkg-install-package {
	old_dir=$(pwd)
	cd $1
	yarn install $2 --silent >/dev/null 2>&1
	ret_val=$?
	cd $old_dir
	return $ret_val
}

function njspkg-update-app {
	old_dir=$(pwd)
	cd $1
	yarn upgrade --silent >/dev/null 2>&1
	ret_val=$?
	cd $old_dir
	return $ret_val
}

function njspkg-install-global {
	npm global install $1 --silent >/dev/null 2>&1
}

function njspkg-update-global {
	npm global update --silent >/dev/null 2>&1
}
