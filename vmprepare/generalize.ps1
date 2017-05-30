#
# This script will generalize and capture a deprovisioned azure VM
# 
# Prerequisites:
# The script have to be executed on a remote computer
# You will need Azure RM v4.0+ powershell module on your machine to run these commands
# The VM have to be already deprivisioned with command "waagent -deprovision+user -force"
# You will need owner permissions on the Azure account
# 
# Notes:
# It's higly recommended to run this script line-by-line intead of as a batch.
# These commands are interactive ones and you may have to do some extra steps according to the output of the commands.
#
# Project page:
# https://github.com/tresorit/ZeroKit-Azure-marketplace-VM
#
# Licence: BSD 3-Clause License
#
# (C) Copyright 2017 by Tresorit AG.
#

#
# Configuration values for the script
#
$subscriptionId = ""    # AZure subscription id
$resourceGroup = ""     # Resource group name where the VM is created
$imageContainer = ""    # Container where ti put the generalized image
$imagePrefix = ""       # prefix for the image's filename
$localTemplatePath = "" # A valid local path where to save the Azure resource template of the image
$vmName = ""            # Name of the image

# Logs in to azure resource manager
Login-AzureRmAccount

# Gets the list of your Azure subscriptions
Get-AzureRmSubscription

# Selects the proper
Select-AzureRmSubscription -SubscriptionId $subscriptionId

# Gets the VM object
$vm = Get-AzureRmVM -ResourceGroupName $resourceGroup -Name $vmName -Status

# Stops the VM
Stop-AzureRmVM -ResourceGroupName $resourceGroup -Name $vmName

# Sets the VM as generalized VM
Set-AzureRmVM -ResourceGroupName $resourceGroup -Name $vmName -Generalized

# Gets the VM's status
$vm = Get-AzureRmVM -ResourceGroupName $resourceGroup -Name $vmName -Status

# Captures the generalized image
Save-AzureRmVMImage -ResourceGroupName $resourceGroup -Name $vmName -DestinationContainerName $imageContainer -VHDNamePrefix $imagePrefix -Path $localTemplatePath
