In computer networks setting a static IP address for a client might be
necessary. One way to do it is on the client side by setting the related
interface configurations to the required values.

## Modifying the configuration
On systems running Ubuntu, it can be achieved by modifying the netplan
config file for the designated interface.

On Ubuntu 18.04 the netplan config file is `/etc/netplan/01-netcfg.yaml`
which contains the interface values in YAML format. Because of that, the
indentation is important in the file!

The file is protected from normal users, therefore we need superuser
rights too to open it for editing. Execute the following code to edit
with nano:

`sudo nano /etc/netplan/01-netcfg.yaml`{{execute}}

## Settings usable in YAML
For a simple static IP, the YAML file needs to contain the IP address(es),
subnet mask and the gateway and the nameservers for the interface.

A basic description looks like this for the `eth0` interface:

<pre class="file" data-filename="file" data-target="append">
network:
    version: 2
    renderer: networkd
    ethernets:
        eth0:
            dhcp4: no
            dhcp6: no
            addresses: [192.168.5.10/24]
            gateway4: 192.168.5.1
            nameservers:
                addresses: [1.1.1.1, 8.8.8.8, 8.8.4.4]
</pre>

## Saving the file
On Ubuntu, the usual CTRL+S save shortcut is set up for nano. The other
way is CTRL+O and then specifying the filename and accepting it.

You can leave nano by pressing CTRL+X.