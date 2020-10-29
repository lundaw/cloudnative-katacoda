Editing the configuration file does not immediately apply the settings
on the interfaces contained in the configuration file.

## Applying the configuration
In order to apply the configuration, ask `netplan` to read the config
files again, parse them and apply the settings by running the
`sudo netplan apply`{{execute}} command.

If you would like to see more verbose output and see the process in
detail, run it with `--debug` such as `sudo netplan --debug apply`{{execute}}.

## Check the result
You can check the successful modification the same way as in Step 1, by
running the `ip a`{{execute}} command.