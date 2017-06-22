# ZeroKit sample backend Realm.io edition for Azure marketplace
This is a small, easy-to-install VM for Azure marketplace. The VM self-hosts a ZeroKit sample backend along with its Realm mobile database, Realm Object Server (developer edition) installation and a management utility. After a minimal configuration it can be used to quickly start the mobile development with ZeroKit and Realm.

**Notes for web developers:** This is a modified, Realm-enabled version of the standard ZeroKit sample backend. You can find the original VM description [here](https://github.com/tresorit/ZeroKit-Azure-marketplace-vm).

**Warning:** This VM is created only for development and evaluation purposes. It does not create or install any HTTPS certificates, and not suitable for scaling-out (installing on clusters of multiple VMs).
If you want to use the sample server as the base of your production code, then we highly recommend to use our raw [ZeroKit-Realm backend project](https://github.com/tresorit/ZeroKit-NodeJs-backend-sample-realm) and install it into a production-grade environment. If you want to use it in an environment where multiple VMs server as the backend, then you will need the Professional or Enterprise edition of Realm mobile platform.

# Purchase
You can purchase the VM from MS Azure marketplace. The VM itself is free, but you will need an Azure subscription and depending on your chosen VM size and resource usage, you may be charged by Microsoft.

Upon VM purchase, we highly recommend to modify default network settings and set up the VM to use a **static** ip address.

**Warning:** Static IP usage may cost more.

![Static IP setting](https://github.com/tresorit/ZeroKit-Azure-marketplace-vm/raw/master/.images/azure-purchase-static-ip.PNG)

# VM access
After instantiation has completed, please copy public ip address of your newly created vm. You can find it on the main configuration page of the VM on the Azure portal.

![Azure VM dashboard](https://github.com/tresorit/ZeroKit-Azure-marketplace-vm/raw/master/.images/azure-vm-dashboard.PNG)

You can access your Vm through this ip address.

To log in to your machine, you should use ssh:
- From linux use command "ssh {your-vm-user}@{your-vm-id}", and use your password.
- From windows, you can use [Putty](http://www.putty.org/) application's gui for this.

# Prepare your tenant
Now you can configure your ZeroKit tenant at https://manage.tresorit.io. to use this VM as an application server. Assuming that your ip iddress is {yout-vm-ip}, and that you will use our ZeroKit-Realm mobile example project, you should setup the following things on https://manage.tresorit.io:

 1.  Add "http://localhost:3002" as an allowed origin (This will be useful if you want to try our web sample later.)
 
 2.  Go to the "Identity provider" section

 3. Add an SDK client with the following data:
  - name: your choice, its only for display on the portal
  - Other parameters are pre-set for you.
  - You will later need the client id the secret and the redirect URL from this page, but you can come back and copy them any time.
  - Click "apply". You should wait 2-5 minutes for the change to be effective, in that time you can configure your app server Vm.

  ![IDP client configuration](https://github.com/tresorit/ZeroKit-Azure-marketplace-vm/raw/master/.images/zerokit-realm-idp-client.png)

# Configure your VM

1. At first, you should log in to your vm with ssh.
  - From linux "ssh {your-vm-user}@{your-vm-id}", and use your password.
  - From windows, you can use [Putty](http://www.putty.org) application's gui for this.

2. After login, please run command "sudo su". This will elevate your session's privileges. (Sytsem will may prompt you to re-enter your password.)

3. As root user, edit /etc/zerokit/config.json.

**Tip:** You can type "zkitadm config" command to configure your VM.
- You should not change SDK version, it is preset for you.
- You should provide information from https://manage.tresorit.io according to the comments in the config file.

  Your config file should look like this one, but with your own data:

  ```js
  {
    "dbUrl": "mongodb://127.0.0.1:27017/zerokit",
    "baseUrl": "http://123.123.123.123",
    "appOrigins": ["http://localhost:3002"],
    "zeroKit": {
        "serviceUrl": "https://yourtenant.api.tresorit.io",
        "adminUserId": "admin@yourtenant.tresorit.io",
        "adminKey": "0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef",
        "sdkVersion": "4",
        "idp": [
            {
                "clientID": "yourtenant_abcdeabcde_sdk",
                "clientSecret": "AbcdEfgHIj123456"
            }
        ]
      }
  }
  ```

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

  5. Now you can configure the pre-installed Realm Object Server instance to accept authentication tokens from your ZeroKit tenant.
  - To access config please type 'zkitadm realm config' command into the command line or edit /etc/realm/configuration.yaml file directly.
  - Find the *custom/zerokit* section within *auth* and *providers* sections and copy your own IDP client ID, client secret and tenant service url from the https://manage.tresorit.io portal.
    **Hint:** These are the same values that you used in the previous steps.
  - You should not change *include path* or *implementation* values. They are preset for you according to the installation.

  Your config section should look like this one, but with your own data:

  ```yaml
   # This enables login via ZeroKit's secure identity provider
    custom/zerokit:
      # The client ID of the IDP client created for the Realm object server
      # on ZeroKit management portal (https://manage.tresori.io)
      client_id: 'yourtenant_abcdeabcde_sdk'

      # The client secret of the IDP client created for the Realm object server
      # on ZeroKit management portal (https://manage.tresori.io)
      client_secret: 'AbcdEfgHIj123456'

      # The service URL of your ZeroKit tenant. It can be found on the main
      # configuration page of your tenant on ZeroKit management portal
      # (https://manage.tresori.io)
      service_url: 'https://yourtenant.api.tresorit.io'

      # The include path to use for including ZeroKit auth implementation.
      # Usually it's /usr/local/zerokit/zerokit-realm-auth-provider
      include_path: '/usr/local/zerokit/zerokit-realm-auth-provider'

      # This refers to the actual implementation (should be zerokitauth)
      implementation: 'zerokitauth'
  ```

# Setup example mobile apps
You can find our ZeroKit+Realm enabled mobile example apps [here](https://github.com/tresorit/ZeroKit-Realm-encrypted-tasks). This is a modified version of the original [Realm-tasks](https://github.com/realm-demos/realm-tasks) example app by Realm.io extended with

- ZeroKit auth
- End-to-end encryption by ZeroKit
- Sharing

You can skip the backend configuration described in the app's repo, as you already configured one with this VM. :-)

You can find the [Android app instructions here](https://github.com/tresorit/ZeroKit-Realm-encrypted-tasks/tree/master/android) and the [iOS instructions here](https://github.com/tresorit/ZeroKit-Realm-encrypted-tasks/tree/master/ios).

# The zkitadm utility
The installation by default contains an interactive utility called "zkitadm", which helps to manage your ZeroKit sample backend installation on the VM.
You can read more about the utility [here](https://github.com/tresorit/ZeroKit-Azure-marketplace-vm/tree/master/zkitadm).

For managing the integrated Realm Object Server (developer edition) you can also use ["zkitadm" utility's *realm* subcommand.](https://github.com/tresorit/ZeroKit-Azure-marketplace-vm/blob/master/zkitadm/REALM.README.md)
