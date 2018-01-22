#!/bin/bash
useradd zabbix &&
sed -i "s/enabled=1/enabled=0/g" /etc/yum.repos.d/epel.repo 
useradd zabbix -g zabbix
yum install gcc* -y
cd /
tar zxvf zabbix-3.0.4.tar.gz &&
cd zabbix-3.0.4 &&
 ./configure --enable-agent &&
make && make install &&
scp -r 192.168.80.33:/zabbix-3.0.4/conf/zabbix_agentd.conf /zabbix-3.0.4/conf/zabbix_agentd.conf
cd /zabbix-3.0.4/conf
zabbix_agentd -c /zabbix-3.0.4/conf/zabbix_agentd.conf 
 setenforce 0
/etc/init.d/iptables stop