#
# This script will instantiate a VM from a generalized image
# 
# Prerequisites:
# The script have to be executed on a remote computer
# You will need Azure RM v4.0+ powershell module on your machine to run these commands
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
# Settings for the VM to create
#

# URL of the generalized VM image
$imageURI = ""

# Name of the storage account where the VHD is located. This example sets the 
# storage account name as "myStorageAccount"
$storageAccName = ""

# Name prefix for the resources
$prefix = "azure-market"

# Name of the resource group to create for the new VM
$rgName = "$prefix-resourcegroup"

# Deployment location
$location = "North Europe"

# Name of the network subnet of the resource group
$subnetName = "$prefix-subnet"

# Name of the virtual network to create
$vnetName = "$prefix-vnet"

# Name o fthe IP address to create
$ipName = "$prefix-ip"

# Name o fthe network interface to create for the VM
$nicName = "$prefix-nic"

# Name of the network security group to create
$nsgName = "$prefix-nsg"

# Name of the virtual machine. This example sets the VM name as "myVM".
$vmName = "$prefix-vm"

# Size of the virtual machine. This example creates "Standard_D2_v2" sized VM. 
# See the VM sizes documentation for more information: 
# https://azure.microsoft.com/documentation/articles/virtual-machines-windows-sizes/
$vmSize = "Basic_A0"

# Computer name for the VM. This examples sets the computer name as "myComputer".
$computerName = "$prefix-computer"

# Name of the disk that holds the OS. This example sets the 
# OS disk name as "myOsDisk"
$osDiskName = "$prefix-disc"

# Assign a SKU name. This example sets the SKU name as "Standard_LRS"
# Valid values for -SkuName are: Standard_LRS - locally redundant storage, Standard_ZRS - zone redundant
# storage, Standard_GRS - geo redundant storage, Standard_RAGRS - read access geo redundant storage,
# Premium_LRS - premium locally redundant storage. 
$skuName = "Standard_LRS"

# Creating  subnet
$singleSubnet = New-AzureRmVirtualNetworkSubnetConfig -Name $subnetName -AddressPrefix 10.0.0.0/24

# Creating virtual network
$vnet = New-AzureRmVirtualNetwork -Name $vnetName -ResourceGroupName $rgName -Location $location -AddressPrefix 10.0.0.0/16 -Subnet $singleSubnet

# Creating a public IP address
$pip = New-AzureRmPublicIpAddress -Name $ipName -ResourceGroupName $rgName -Location $location -AllocationMethod Static

# Creating a network interface
$nic = New-AzureRmNetworkInterface -Name $nicName -ResourceGroupName $rgName -Location $location -SubnetId $vnet.Subnets[0].Id -PublicIpAddressId $pip.Id

# Adding firewall rules to the network security group
$sshRule = New-AzureRmNetworkSecurityRuleConfig -Name SSH -Description "SSH" -Access Allow -Protocol Tcp -Direction Inbound -Priority 110 -SourceAddressPrefix Internet -SourcePortRange * -DestinationAddressPrefix * -DestinationPortRange 22
$httpRule = New-AzureRmNetworkSecurityRuleConfig -Name HTTP -Description "HTTP" -Access Allow -Protocol Tcp -Direction Inbound -Priority 120 -SourceAddressPrefix Internet -SourcePortRange * -DestinationAddressPrefix * -DestinationPortRange 80
$httpsRule = New-AzureRmNetworkSecurityRuleConfig -Name HTTPS -Description "HTTPS" -Access Allow -Protocol Tcp -Direction Inbound -Priority 130 -SourceAddressPrefix Internet -SourcePortRange * -DestinationAddressPrefix * -DestinationPortRange 443

# Creating the network security group
$nsg = New-AzureRmNetworkSecurityGroup -ResourceGroupName $rgName -Location $location -Name $nsgName -SecurityRules $sshRule,$httpRule,$httpsRule

# Enter a new user name and password to use as the local administrator account 
# for remotely accessing the VM.
$cred = Get-Credential

# Get the storage account where the uploaded image is stored
$storageAcc = Get-AzureRmStorageAccount -ResourceGroupName $rgName -AccountName $storageAccName

# Set the VM name and size
$vmConfig = New-AzureRmVMConfig -VMName $vmName -VMSize $vmSize

#Set the Windows operating system configuration and add the NIC
$vm = Set-AzureRmVMOperatingSystem -VM $vmConfig -Linux -ComputerName $computerName -Credential $cred
$vm = Add-AzureRmVMNetworkInterface -VM $vm -Id $nic.Id

# Create the OS disk URI
$osDiskUri = '{0}images/{1}-{2}.vhd' -f $storageAcc.PrimaryEndpoints.Blob.ToString(), $vmName.ToLower(), $osDiskName

# Configure the OS disk to be created from the existing VHD image (-CreateOption fromImage).
$vm = Set-AzureRmVMOSDisk -VM $vm -Name $osDiskName -VhdUri $osDiskUri -CreateOption fromImage -SourceImageUri $imageURI -Linux

# Create the new VM
New-AzureRmVM -ResourceGroupName $rgName -Location $location -VM $vm
