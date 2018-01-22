#!/bin/bash
InfoFilePath=/tmp/info.log
date '+%-Y-%m-%d %-H:%-M:%-S' >$InfoFilePath
(cat  <<EOF
if [ -f /proc/net/bonding/bond0 ] ;then IFNAME=bond0;else IFNAME=eth0;fi
SN=\`dmidecode -s system-serial-number|grep -v  '^#'|sed 's/ //g'\`
HOST=\`hostname\`
IPADDR=\`grep IPADDR /etc/sysconfig/network-scripts/ifcfg-\$IFNAME |awk -F[=] '{print \$2}'\`
IPMI=\`ipmitool lan print |grep 'IP Address              : ' |sed -e 's/IP Address  *: //g'\`
PRONAME=\`dmidecode -s system-product-name|grep -v  '^#'|sed 's/ //g'\`
INFO="\${HOST} \${IPADDR} \${IPMI} \${SN} \${PRONAME}"
echo \${INFO} |tr ' ' '\\t'
rm -rf ~/sn.scr
EOF
)>/tmp/getinfo.sh
for a in `awk '{print $2}' /home/ngis/nfs/sn2hosts`
do 
	ssh $a "`cat /tmp/getinfo.sh`" | tee -a $InfoFilePath
done
for c in `awk '{print $3}' $InfoFilePath`
do
	/usr/bin/expect<<EOF
	set timeout 2
	spawn ipmitool -I lanplus -U taobao -P 9ijn0okm sol activate -H $c
	expect "SOL"
	send "\r"
	expect "login:"
	send "~"
	send "~.\r"
	expect eof
EOF
done | tee -a $InfoFilePath
rm -rf /tmp/getinfo.sh

