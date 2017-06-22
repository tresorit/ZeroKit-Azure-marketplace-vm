# Realm subcommand for Zkitadm utility
The realm subcommand provide functionality to manage the integrated Realm Object Server (developer) edition through zkitadm.

## Usage
Zkitadm realm subcommand also has subcommands, like git. The list of the currently available commands is:

  - **help** - Prints this screen
  - **status** - Prints hosting process status
  - **restart** - Restarts hosting process
  - **stop** - Stops service
  - **start** - Starts service
  - **logs** - Prints live log stream
  - **check** - Checks whether service can be updated with aptitude package manager
  - **upgrade** - Upgrades service from original git repository
  - **config** - Opens configuration file for editing


### Help
Will print help screen of the available commands

```bash
> zkitadm realm help

Usage : zkitadm realm <command>

Commands :
  help    - Prints this screen
  status  - Prints hosting process status
  restart - Restarts hosting process
  stop    - Stops service
  start   - Starts service
  logs    - Prints live log stream
  check   - Checks whether service can be updated with aptitude package manager
  upgrade - Upgrades service by aptitude package manager
  config  - Opens configuration file for editing
```

### Status
Prints out the status of the current hosting process

```bash
> zkitadm realm status
● realm-object-server.service - Realm Object Server
   Loaded: loaded (/etc/systemd/system/realm-object-server.service; enabled; vendor preset: enabled)
   Active: active (running) since Thu 2017-06-22 11:38:11 UTC; 1h 35min ago
 Main PID: 38259 (realm-object-se)
    Tasks: 28
   Memory: 111.0M
      CPU: 1min 47.783s
   CGroup: /system.slice/realm-object-server.service
           ├─38259 /usr/lib/realm-object-server-developer/node/bin/node /usr/bin/realm-object-server -c /etc/realm/configuration.yml
           ├─38297 statsd {"flushInterval":10000,"flush":true}
           └─38309 /usr/lib/realm-object-server-developer/node/bin/node /usr/lib/nodejs/realm-object-server-developer/node_modules/realm-functions/lib/wrapper

Jun 22 11:38:11 zerokit-realm-testvm systemd[1]: Started Realm Object Server.
Jun 22 11:38:20 zerokit-realm-testvm realm-object-server[38259]: 2017-06-22T11:38:20.411Z - info: Logging to file /var/log/realm-object-server.log at level 'info'.

```

### Config
Config command will open the Realm Object Server configuration file for editing with the system-default editor.

**Note:** The Realm Object Server have to be restarted after the config file modification.

```bash
> zkitadm realm config

The service has to be restarted to read new settings. Please use "zkitadm realm restart" command
```

### Logs
Will print the last logs and start to stream the new ones. You may exit streaming mode with *Ctrl+c*.

```bash
>  zkitadm realm logs
2017-06-22T11:57:40.427Z - info: sync-server: Sync Connection[47]: Session[22]: Received: IDENT(server_file_ident=1, client_file_ident=2, client_file_ident_secret=8871974368683920617, scan_server_version=15, scan_client_version=34, latest_server_version=15, latest_server_session_ident=1211555222486385725)
2017-06-22T11:57:40.565Z - info: sync-server: Sync Connection[48]: Session[23]: Session initiated (session_ident=23).
2017-06-22T11:57:40.565Z - info: sync-server: Sync Connection[48]: Session[23]: Received: BIND(server_path=/__permission, signed_user_token='...', need_file_ident_pair=0)
2017-06-22T11:57:40.565Z - info: sync-server: Sync Connection[48]: Session[23]: Received: IDENT(server_file_ident=1, client_file_ident=2, client_file_ident_secret=4002425035014175120, scan_server_version=38, scan_client_version=82, latest_server_version=38, latest_server_session_ident=4182561355294655078)
2017-06-22T11:57:40.702Z - info: client: Closing Realm file: /var/lib/realm/object-server/internal_data/permission/acbc294569568c283fee2ab48630383c.realm
2017-06-22T11:57:40.703Z - info: client: Connection[22]: Session[22]: Sending: UNBIND
2017-06-22T11:57:40.704Z - info: sync-server: Sync Connection[47]: Session[22]: Session terminated (session_ident=22).
2017-06-22T11:57:40.704Z - info: sync-server: Sync Connection[47]: Connection closed by client: End of input
2017-06-22T11:57:40.810Z - info: client: Closing Realm file: /var/lib/realm/object-server/internal_data/permission/__global.realm
2017-06-22T11:57:40.810Z - info: client: Connection[23]: Session[23]: Sending: UNBIND
2017-06-22T11:57:40.811Z - info: sync-server: Sync Connection[48]: Session[23]: Session terminated (session_ident=23).
2017-06-22T11:57:40.811Z - info: sync-server: Sync Connection[48]: Connection closed by client: End of input
2017-06-22T11:58:58.465Z - info: sync-server: Sync Connection[46]: Session[1]: Session terminated (session_ident=1).
2017-06-22T11:58:58.466Z - info: sync-server: Sync Connection[46]: Connection closed by client: End of input
2017-06-22T11:58:58.467Z - info: sync-server: Sync Connection[44]: Session[1]: Session terminated (session_ident=1).
2017-06-22T11:58:58.467Z - info: sync-server: Sync Connection[44]: Connection closed by client: End of input
2017-06-22T11:58:58.468Z - info: sync-server: Sync Connection[45]: Session[1]: Session terminated (session_ident=1).
2017-06-22T11:58:58.468Z - info: sync-server: Sync Connection[45]: Connection closed by client: End of input
2017-06-22T11:58:58.468Z - info: sync-server: Sync Connection[43]: Session[1]: Session terminated (session_ident=1).
2017-06-22T11:58:58.468Z - info: sync-server: Sync Connection[43]: Connection closed by client: End of input
```

## Check
Checks if the ROS installation can be updated with APT.

```bash
> zkitadm realm check
realm-object-server-developer
Realm Object server can be updated. Please run 'zkitadm realm upgrade' command
```

### Start
Starts the ROS service if it was stopped previously.

```bash
> zkitadm realm start
```

### Stop
Stops the ROS service if it was running.

```bash
> zkitadm realm stop
```

### Restart
Restarts the ROS service if it was running.

```bash
> zkitadm realm restart
```

### Upgrade
Upgrades Realm Object Server (developer edition) with APT package manager.

**Note:** This command will stop the database service before update and restart it after. This may cause 1-2 minutes of service interruption.

```bash
> zkitadm realm upgrade
This command will upgrage Realm object server with aptitude package manager.
Are you sure? y
Updating Realm object server...[OK]
```
