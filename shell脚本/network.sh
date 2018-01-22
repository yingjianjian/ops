#!/bin/bash
filename="/etc/sysconfig/network-scripts/ifcfg-eth0"
Hostname="/etc/sysconfig/network"
udev="/etc/udev/rules.d/70-persistent-net.rules "
sed -i "s/^HWA/#&/" $filename
sed -i "s/^MM/#&/" $filename
sed -i "4i\DNS1=114.114.114.114"  $filename
sed -i "s/^\(BOOTPROTO=\).*/\1static/" $filename
printf "hostname is:"
read hostname &&
sed -i "s/^\(HOSTNAME=\).*/\1$hostname/" $Hostname
printf "ipaddres is:"
read ipaddr &&
sed -i "s/^\(IPADDR=\).*/\1$ipaddr/" $filename
printf "NETMASK is:"
read netmask &&
sed -i "s/^\(NETMASK=\).*/\1$netmask/" $filename
printf "GATEWAY is:"
read gateway &&
sed -i "s/^\(GATEWAY=\).*/\1&gateway/" $filename
rm -rf $udev
reboot
