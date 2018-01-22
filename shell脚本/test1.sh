#!/bin/bash
#---------------------------------------------------------------------------------------------------------------------
if [ -d /tmp/log ];then
  rm -rf /tmp/log/*
  echo "/tmp/log is exist"
else
  mkdir /tmp/log
  echo "create /tmp/log"
fi

#---------------------------------------------------------------------------------------------------------------------
Connect(){
      num=$(($#-1))
      eval cmd="\$$#"
         echo -e "\033[32;1m=========================== $HOST ===========================\033[0m";
         ssh -o ConnectTimeout=5 $HOST $cmd
      echo
      unset HOST
}

#---------------------------------------------------------------------------------------------------------------------
DIR="/tmp/log"
for HOST in `cat /home/ngis/nfs/sn2hosts | awk '{ print $2 }'`
do
  Connect $HOST "hwconfig | grep 'Disk:' | wc -l;hwconfig | grep 'Disk:'"                             | tee -a $DIR/disk
  Connect $HOST "cat /proc/cpuinfo | grep 'cpu cores' | uniq;cat /proc/cpuinfo | grep sibling | uniq" | tee -a $DIR/cpuinfo
  Connect $HOST "hwconfig | grep 'Memory:'"                                                           | tee -a $DIR/memory
  Connect $HOST "fdisk -l /dev/sda | grep \"/dev/sda\""                                               | tee -a $DIR/sda
  Connect $HOST "cat /etc/issue"                                                                      | tee -a $DIR/issue
  Connect $HOST "df -h"                                                                               | tee -a $DIR/partition
  Connect $HOST "host www.alipay.com"                                                                 | tee -a $DIR/dns-test
  Connect $HOST "ethtool eth0 | egrep 'Speed|detected'"                                               | tee -a $DIR/eth0
  Connect $HOST "netstat -nrt"                                                                        | tee -a $DIR/host-route-tables
  Connect $HOST "cat /etc/resolv.conf | grep nameserver | egrep -v '110.75.1.30'"                     | tee -a $DIR/local-dns
  Connect $HOST "ping -c 300 `route -n | sed -n '/^0.0.0.0/p' | awk '{print $2}'` -f | egrep 'ms|ping'"                                     | tee -a $DIR/ping-test
  Connect $HOST "uname -a"                                                                            | tee -a $DIR/kernel
  Connect $HOST "service ntpd stop;ntpdate ntp2.alibaba-inc.com; hwclock -w;service ntpd start"       | tee -a $DIR/ntpdate
  Connect $HOST "ntpq -p"                                                                             | tee -a $DIR/ntpserver
  Connect $HOST "chkconfig --list  | grep '3:on'"                                                     | tee -a $DIR/online-service
  Connect $HOST "cat /proc/net/bonding/bond0"                                                         | tee -a $DIR/bond   
  Connect $HOST "ifconfig | grep 'inet addr'"                                                         | tee -a $DIR/service-ip
  Connect $HOST "ipmitool user test 3 16 9ijn0okm"                                                    | tee -a $DIR/oob-user-test
  Connect $HOST "ipmitool -I open lan print | grep -m 1 '10.'"                                        | tee -a $DIR/oob-ip
  Connect $HOST "ipmitool sel clear;ipmitool sel list"
done
i=`route -n | sed -n '/^0.0.0.0/p' |awk -F . '{print $7}' | awk '{print $1}'`
a=`route -n | sed -n '/^0.0.0.0/p' | awk -F . '{print $4"."$5"."$6}'|awk '{print $2}'`
b=`sed -n '/^NET/p' /etc/sysconfig/network-scripts/ifcfg-eth0 |sed 's/NETMASK=//g'`
if [ "$i" -eq "126" ]&&[ "$b" == "255.255.255.128" ];then
	echo "$a.0/25"
	ssh 183.129.150.202 "nmap -p 22,80 $a.0/25"  | tee -a $DIR/nmap-port 
elif [ "$i" -eq "126" ]&&[ "$b" == "255.255.255.192" ];then
	echo "$a.64/26"
	ssh 183.129.150.202 "nmap -p 22,80 $a.64/26"  | tee -a $DIR/nmap-port
elif [ $b == "255.255.255.0" ]&&[ $i -eq 247 ];then
	echo "$a.0/24"
	ssh 183.129.150.202 "nmap -p 22,80 $a.0/24"  | tee -a $DIR/nmap-port
elif [ $b == "255.255.255.128" ]&&[ $i -eq 247  ];then
	echo "$a.128/25"
	ssh 183.129.150.202 "nmap -p 22,80 $a.128/25"  | tee -a $DIR/nmap-port
elif [ "$i" -eq "190" ]&&[ "$b" == "255.255.255.192" ];then
	echo "$a.128/26"
	ssh 183.129.150.202 "nmap -p 22,80 $a.128/26"  | tee -a $DIR/nmap-port
elif [ "$i" -eq "247" ]&&[ "$b" =="255.255.255.192" ];then
	echo "$a.192/26"
	ssh 183.129.150.202 "nmap -p 22,80 $a.192/26"  | tee -a $DIR/nmap-port
elif [ "$i" -eq "62" ]&&[ "$b" == "255.255.255.192" ];then
	echo "$a.0/26"
	ssh 183.129.150.202 "nmap -p 22,80 $a.0/26"  | tee -a $DIR/nmap-port
fi
