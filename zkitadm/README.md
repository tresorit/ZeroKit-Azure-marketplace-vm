# Zkitadm utility
Zkitadm is a small, interactive command line utility to manage ZeroKit sample backend installation purchased from Azure marketplace.

To use the utility you have to be root. Use "sudo" or "sudo su" command to acquire root privileges from a shell.

## Usage
Zkitadm utility has subcommands, like git. The list of the currently available commands is:

  - **help** - Prints this screen
  - **status** - Prints hosting process status
  - **restart** - Restarts hosting process
  - **stop** - Stops service
  - **start** - Starts service
  - **update** - Updates NPM packages used by the server
  - **upgrade** - Upgrades service from original git repository
  - **config** - Opens configuration file for editing


### Help
Will print help screen of the available commands

```bash
> zkitadm help

Usage : zkitadm command

Commands :
  help    - Prints this screen
  status  - Prints hosting process status
  restart - Restarts hosting process
  stop    - Stops service
  start   - Starts service
  update  - Updates NPM packages used by the server
  upgrade - Upgrades service from original git repository
  config  - Opens configuration file for editing

```

### Status
Prints out the status of the current hosting process

```bash
> zkitadm status

┌──────────┬────┬──────┬──────┬────────┬─────────┬────────┬─────┬───────────┬──────────┐
│ App name │ id │ mode │ pid  │ status │ restart │ uptime │ cpu │ mem       │ watching │
├──────────┼────┼──────┼──────┼────────┼─────────┼────────┼─────┼───────────┼──────────┤
│ zerokit  │ 0  │ fork │ 3966 │ online │ 52180   │ 6h     │ 0%  │ 61.0 MB   │ disabled │
└──────────┴────┴──────┴──────┴────────┴─────────┴────────┴─────┴───────────┴──────────┘
```

### Config
Config command will open the ZeroKit sample backend's config file for editing with the system-default editor.

**Note:** The sample backend have to be restarted after the config file modification.

```bash
> zkitadm config

The service have to be restarted to read new settings. Please use "zkitadm restart" command.
```

### Logs
Will print the last logs and start to stream the new ones. You may exit streaming mode with *Ctrl+c*.

```bash
> zkitadm logs

[TAILING] Tailing last 15 lines for [zerokit] process (change the value with --lines option)
/root/.pm2/logs/zerokit-error-0.log last 15 lines:
0|zerokit  |     at Module.require (module.js:498:17)
0|zerokit  |     at require (internal/module.js:20:19)
0|zerokit  |     at Object.<anonymous> (/var/www/zerokit/bin/www:7:11)
0|zerokit  |     at Module._compile (module.js:571:32)
0|zerokit  | TypeError: Cannot read property '1' of null
0|zerokit  |     at Object.<anonymous> (/var/www/zerokit/app.js:44:44)
0|zerokit  |     at Module._compile (module.js:571:32)
0|zerokit  |     at Object.Module._extensions..js (module.js:580:10)
0|zerokit  |     at Module.load (module.js:488:32)
0|zerokit  |     at tryModuleLoad (module.js:447:12)
0|zerokit  |     at Function.Module._load (module.js:439:3)
0|zerokit  |     at Module.require (module.js:498:17)
0|zerokit  |     at require (internal/module.js:20:19)
0|zerokit  |     at Object.<anonymous> (/var/www/zerokit/bin/www:7:11)
0|zerokit  |     at Module._compile (module.js:571:32)

/root/.pm2/logs/zerokit-out-0.log last 15 lines:
0|zerokit  |     at Layer.handle [as handle_request] (/var/www/zerokit/node_modules/express/lib/router/layer.js:95:5)
0|zerokit  |     at trim_prefix (/var/www/zerokit/node_modules/express/lib/router/index.js:317:13)
0|zerokit  |     at /var/www/zerokit/node_modules/express/lib/router/index.js:284:7
0|zerokit  |     at Function.process_params (/var/www/zerokit/node_modules/express/lib/router/index.js:335:12)
0|zerokit  |     at next (/var/www/zerokit/node_modules/express/lib/router/index.js:275:10)
0|zerokit  |     at SessionStrategy.strategy.pass (/var/www/zerokit/node_modules/passport/lib/middleware/authenticate.js:325:9)
0|zerokit  |     at SessionStrategy.authenticate (/var/www/zerokit/node_modules/passport/lib/strategies/session.js:71:10)
0|zerokit  |     at attempt (/var/www/zerokit/node_modules/passport/lib/middleware/authenticate.js:348:16)
0|zerokit  |     at authenticate (/var/www/zerokit/node_modules/passport/lib/middleware/authenticate.js:349:7)
0|zerokit  |     at Layer.handle [as handle_request] (/var/www/zerokit/node_modules/express/lib/router/layer.js:95:5)
0|zerokit  |     at trim_prefix (/var/www/zerokit/node_modules/express/lib/router/index.js:317:13)
0|zerokit  |     at /var/www/zerokit/node_modules/express/lib/router/index.js:284:7
0|zerokit  |     at Function.process_params (/var/www/zerokit/node_modules/express/lib/router/index.js:335:12)
0|zerokit  |     at next (/var/www/zerokit/node_modules/express/lib/router/index.js:275:10)
0|zerokit  |     at initialize (/var/www/zerokit/node_modules/passport/lib/middleware/initialize.js:53:5) status: 404, code: 'NotFound' }

[STREAMING] Now streaming realtime logs for [zerokit] process
```

### Start
Starts the backend service if it was stopped previously.

```bash
> zkitadm start

[PM2] Applying action restartProcessId on app [zerokit](ids: 0)
[PM2] [zerokit](0) ✓
[PM2] Process successfully started
┌──────────┬────┬──────┬──────┬────────┬─────────┬────────┬─────┬───────────┬──────────┐
│ App name │ id │ mode │ pid  │ status │ restart │ uptime │ cpu │ mem       │ watching │
├──────────┼────┼──────┼──────┼────────┼─────────┼────────┼─────┼───────────┼──────────┤
│ zerokit  │ 0  │ fork │ 6978 │ online │ 52181   │ 0s     │ 33% │ 13.2 MB   │ disabled │
└──────────┴────┴──────┴──────┴────────┴─────────┴────────┴─────┴───────────┴──────────┘
```

### Stop
Stops the backend service if it was running.

```bash
> zkitadm stop

[PM2] Applying action stopProcessId on app [zerokit](ids: 0)
[PM2] [zerokit](0) ✓
┌──────────┬────┬──────┬─────┬─────────┬─────────┬────────┬─────┬────────┬──────────┐
│ App name │ id │ mode │ pid │ status  │ restart │ uptime │ cpu │ mem    │ watching │
├──────────┼────┼──────┼─────┼─────────┼─────────┼────────┼─────┼────────┼──────────┤
│ zerokit  │ 0  │ fork │ 0   │ stopped │ 52181   │ 0      │ 0%  │ 0 B    │ disabled │
└──────────┴────┴──────┴─────┴─────────┴─────────┴────────┴─────┴────────┴──────────┘
```

### Restart
Stops the backend service if it was running.

```bash
> zkitadm restart
Use --update-env to update environment variables
[PM2] Applying action restartProcessId on app [zerokit](ids: 0)
[PM2] [zerokit](0) ✓
┌──────────┬────┬──────┬──────┬────────┬─────────┬────────┬─────┬───────────┬──────────┐
│ App name │ id │ mode │ pid  │ status │ restart │ uptime │ cpu │ mem       │ watching │
├──────────┼────┼──────┼──────┼────────┼─────────┼────────┼─────┼───────────┼──────────┤
│ zerokit  │ 0  │ fork │ 7030 │ online │ 52181   │ 0s     │ 0%  │ 12.7 MB   │ disabled │
└──────────┴────┴──────┴──────┴────────┴─────────┴────────┴─────┴───────────┴──────────┘
```

### Update
Updates NPM packages used by the server. This command have to be confirmed.

**Note:** This command will stop the backend service before update and restart it after. This may caues 1-2 minutes of service interruption.

```bash
> zkitadm update
This command will update NPM packages and pm2 process manager used by ZeroKit sample app backend.
Are you sure? y
Stopping service...[OK]

Updating global NPM packages[OK]

Updating server packages[OK]

Restarting app[OK]

┌──────────┬────┬──────┬──────┬────────┬─────────┬────────┬─────┬───────────┬──────────┐
│ App name │ id │ mode │ pid  │ status │ restart │ uptime │ cpu │ mem       │ watching │
├──────────┼────┼──────┼──────┼────────┼─────────┼────────┼─────┼───────────┼──────────┤
│ zerokit  │ 0  │ fork │ 7133 │ online │ 52181   │ 2s     │ 50% │ 39.0 MB   │ disabled │
└──────────┴────┴──────┴──────┴────────┴─────────┴────────┴─────┴───────────┴──────────┘
```

### Upgrade
Updates zkit adm utility and NPM, then upgrades server software fromt he global git repository. (update followed by software update).

**Note:** This command will stop the backend service before update and restart it after. This may caues 1-2 minutes of service interruption.

```bash
> zkitadm upgrade
This command will upgrage ZeroKit sample app backend from central git repository.
Are you sure? y
Stopping service...[OK]

Updating global NPM packages [OK]

Fetching new version from repository [OK]

Triggering update script [OK]

Updating server packages [OK]

Restarting app[OK]

┌──────────┬────┬──────┬──────┬────────┬─────────┬────────┬─────┬───────────┬──────────┐
│ App name │ id │ mode │ pid  │ status │ restart │ uptime │ cpu │ mem       │ watching │
├──────────┼────┼──────┼──────┼────────┼─────────┼────────┼─────┼───────────┼──────────┤
│ zerokit  │ 0  │ fork │ 3664 │ online │ 52180   │ 2s     │ 60% │ 39.9 MB   │ disabled │
└──────────┴────┴──────┴──────┴────────┴─────────┴────────┴─────┴───────────┴──────────┘
```
