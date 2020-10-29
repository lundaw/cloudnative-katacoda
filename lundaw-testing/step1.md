The traditional way to view the actual network interface values are by
running the `ifconfig`{{execute}}. Nowadays it is recommended and mostly
done by the `ip`{{execute}} command, found in the `iproute2` package.

If you don't have it, install it with `sudo apt install iproute2`{{execute}}.

## Checking the values
You can the interfaces and the settings values for all interfaces by
executing the `ip a`{{execute HOST1}} command.

## Understanding the output
The output of the command contains all the interfaces and their MAC and IP
addresses by the following:
- link/ether: the MAC address of the interface.
- inet: IPv4 address, with subnet mask
- brd: IPv4 broadcast address
- inet6: IPv6 address