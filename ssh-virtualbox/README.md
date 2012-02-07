1. In VM Manager, go to File -> Preferences -> Network and add a Host-only adapter if none exists

2. Open setting of VM in VM Manager, Network -> Adapter 2
    - change Attached to: Bridged Adapter
    - Name eth0
    - Adapter Type PCnet-PC II
    - Promiscuous Mode: Allow All
3. Boot VM, sudo nano /etc/network/interfaces and add
    auto eth1
    iface eth1 inet static
        address 192.168.0.50
        netmask 255.255.255.0

4. sudo /etc/init.d/networking restart

5. ifconfig

6. sudo aptitude install openssh-server

