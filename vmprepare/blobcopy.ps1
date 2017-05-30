#
# This script will copy the generalized MV image across storage accounts
# 
# Prerequisites:
# The script have to be executed on a remote computer
# You will need Azure RM v4.0+ powershell module on your machine to run these commands
#
# Project page:
# https://github.com/tresorit/ZeroKit-Azure-marketplace-VM
#
# Licence: BSD 3-Clause License
#
# (C) Copyright 2017 by Tresorit AG.
#

#
# Settings for the VM to create
#

### Generalized image in the original storage account ###
$srcUri = ""

### Destination blob name ###
$destBlob = ""
 
### Source storage account credentials ###
$srcStorageAccount = ""
$srcStorageKey = ""
 
### Destination storage acc credentials ###
$destStorageAccount = ""
$destStorageKey = ""
 
#
# Copy VM image
#
 
### Create the source storage account context ### 
$srcContext = New-AzureStorageContext  –StorageAccountName $srcStorageAccount `
                                        -StorageAccountKey $srcStorageKey  
 
### Create the destination storage account context ### 
$destContext = New-AzureStorageContext  –StorageAccountName $destStorageAccount `
                                        -StorageAccountKey $destStorageKey  
 
### Destination Container Name ### 
$containerName = "images"
 
### Start the asynchronous copy - specify the source authentication with -SrcContext ### 
$blob1 = Start-AzureStorageBlobCopy -srcUri $srcUri `
                                    -SrcContext $srcContext `
                                    -DestContainer $containerName `
                                    -DestBlob $destBlob `
                                    -DestContext $destContext
