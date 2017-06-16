# VM prepare utility
These are the scripts which were used to prepare and build the VM image for Azure marketplace.

## VM preparations steps:
1. Create blank Azure VM (Ubuntu 16.04 LTS)
2. Run prepare.sh script which will configure, deprovision and shut down the VM.
3. Run generalize.ps1 powershell script from a remote machine to capture and generalize the image.
  The script will save the captured image to the given blob container under the same storage account as the original image was created. Also, a local copy of the Azure resource template will be can be used to instantiate the VM.
4. Run instantiate.ps1 powershell script from a remote VM to create a new VM from the captured image. You can now test the image functionality and also run the Azure Certification tool.
5. Run the Azure certification tool from a remote computer to get a certification package from the image. You may also have to answer some questions about the vm.
6. Publish VM through Microsoft Azure partner portal.

## About the image structure
Internally the image has the followign software installed:
- **Nginx** - used as reverse proxy for nodejs app
- **NodeJS 7** - runtime for the server application
- **NPM** - NodeJS package manager for managing the packages
- **PM2** - Enterprise process manager for NodeJS apps
- **UWF** - Firewall management utility
- **MongoDB** - Document database for the backend to persist data
- **ZeroKit sample backend** - Simple backend software to communicate with your client apps and ZeroKit hosted service. Good starting point for your backend software - can easily extended through event hooks.
- **ZeroKit Azure marketplace utility** - wrapper project around sample backend to provide provision and management utilities (this project)

The sample backend software is installed in the /var/www/zerokit software. The backend is hosted with NodeJS through PM2 process manager. Internally the public HTTP(S) ports are forwared proxied by Nginx to the NodeJS app. The configuration file is stored in the /var/www/zerokti folder but it is ignored by git and the file itself is symlinked to /etc/zerokit/config.json.
The management utility is installed at /opt/zerokit. The zkitadm command itself is symlinked from /opt/zerokit/admintools/zkitadm/zkitadm.sh to /usr/local/bin/zkitadm for global availability.

If you want to use HTTPS (SSL), then you have to edit Nginx's config at /etc/nginx/sites-enabled/default. You will also need a proper certificate for it.

The firewall is configured to pass SSH (port 22) and HTTP(S) (port 80/443) requests, but nothing else.