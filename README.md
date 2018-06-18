**Notice:** This project is discontinued and no longer maintained nor supported by Tresorit. This repository only exists for archival purposes.
***

# ZeroKit sample backend for Azure marketplace
This is a small, easy-to-install VM for Azure marketplace. The VM self-hosts a ZeroKit sample backend along with its database and management utility. After a minimal configuration it can be used to quickly start the development with ZeroKit.

**Notes for mobile developers:** This VM is also available with Realm mobile database instead of MongoDB and an integrated Realm Object Server for mobile development. [Please click here to read the documentation of the Realm edition of this VM.](https://github.com/tresorit/ZeroKit-Azure-marketplace-vm/blob/master/REALM.README.md)

**Warning:** This VM is created only for development and evaluation purposes. It does not create or install any HTTPS certificates, and not suitable for scaling-out (installing on clusters of multiple VMs).
If you want to use the sample server as the base of your production code, then we highly recommend to use our [Azure one click installation project](https://github.com/tresorit/ZeroKit-Azure-backend-sample). That uses the same sample server code, but installs it into Azure cloud as a scaleable web application with an SSL certificate issued by Microsoft.

# Purchase
You can purchase the VM from MS Azure marketplace. The VM itself is free, but you will need an Azure subscription and depending on your chosen VM size and resource usage, you may be charged by Microsoft.

Upon VM purchase, we highly recommend to modify default network settings and set up the VM to use a **static** ip address.

**Warning:** Static IP usage may cost more.

![Static IP setting](https://github.com/tresorit/ZeroKit-Azure-marketplace-vm/raw/master/.images/azure-purchase-static-ip.PNG)

# VM access
After instantiation has completed, please copy public ip address of your newly created vm. You can find it on the main configuration page of the VM on the Azure portal.

![Azure VM dashboard](https://github.com/tresorit/ZeroKit-Azure-marketplace-vm/raw/master/.images/azure-vm-dashboard.PNG)

You can access your VM through this ip address.

To log in to your machine, you should use ssh:
- From linux use command "ssh {your-vm-user}@{your-vm-id}", and use your password.
- From windows, you can use [Putty](http://www.putty.org/) application's gui for this.

# Prepare your tenant
Now you can configure your ZeroKit tenant at https://manage.tresorit.io. to use this VM as an application server. Assuming that your ip iddress is {yout-vm-ip}, and at first you will use our sample web app, you should setup the following things on https://manage.tresorit.io:

 1.  Add "http://localhost:3002" as an allowed origin

 2. Create an authorization code flow client with the following data:
  - name: your choice, its only for display on the portal
  - redirect url: http://{your-vm-ip}/api/auth/callback   (where you replace {your-vm-ip} with the public ip of your vm)
    Do not forget to clieck on "Add" button
  - You will later need the client id and secret from this page, but you can come back and copy it any time.
  - Click "apply". You should wait 2-5 minutes for the change to be effective, in that time you can configure your app server Vm.

  ![IDP client configuration](https://github.com/tresorit/ZeroKit-Azure-marketplace-vm/raw/master/.images/tenant-idp-web-client.PNG)

# Configure your VM

1. At first, you should log in to your vm with ssh.
  - From linux "ssh {your-vm-user}@{your-vm-id}", and use your password.
  - From windows, you can use [Putty](http://www.putty.org) application's gui for this.

2. After login, please run command "sudo su". This will elevate your session's privileges. (Sytsem will may prompt you to re-enter your password.)

3. As root user, edit /etc/zerokit/config.json.

**Tip:** You can type "zkitadm config" command to configure your VM.
- You should not change database server settings or SDK version, they are preset for you.
- You should provide information from https://manage.tresorit.io according to the comments in the config file.

4. After you have finished, save the file, and type the following command: "zkitadm restart"
  This will restart the running server with the new config.
  You can check the success by typing "zkitadm status". You should see something like this (the important thing is the "status" column, there you should see "online"):
  ```
  ┌──────────┬────┬──────┬──────┬────────┬─────────┬────────┬─────┬───────────┬──────────┐
  │ App name │ id │ mode │ pid  │ status │ restart │ uptime │ cpu │ mem       │ watching │
  ├──────────┼────┼──────┼──────┼────────┼─────────┼────────┼─────┼───────────┼──────────┤
  │ zerokit  │ 0  │ fork │ 1446 │ online │ 0       │ 117s   │ 0%  │ 51.5 MB   │ disabled │
  └──────────┴────┴──────┴──────┴────────┴─────────┴────────┴─────┴───────────┴──────────┘
  ```
# Setup example web app
**Prerequisites:** You will need NodeJS, NPM and git installed on your machine.
1. On your local machine check out our https://github.com/tresorit/ZeroKit-Web-Sample repository, and follow the instructions to setup that app.
    - In the local app's config.js file setup the following:
   ```js
   window.serverUrl = "http://{your-vm-ip}";
   window.clientId = "{your-ip-client-id}";
   ```

     The client ID is copied from manage.tresorit.io from the IDP client created at the previous step.

  - Then please execute the following commands from the folder of your local app:
  ```bash
  npm install express
  node server.js
  ```
2.  You can try your app. Go to a browser and navigate to http://localhost:3002.
![IDP client configuration](https://github.com/tresorit/ZeroKit-Azure-marketplace-vm/raw/master/.images/web-sample-client.PNG)

# The zkitadm utility
The installation by default contains an interactive utility called "zkitadm", which helps to manage your ZeroKit sample backend installation on the VM.
You can read more about the utility [here](https://github.com/tresorit/ZeroKit-Azure-marketplace-vm/tree/master/zkitadm).
