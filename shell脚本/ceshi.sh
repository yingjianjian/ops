#!/bin/bash
#NODE_TNT_ADDRESS=`cat /tmp/ceshi.txt|awk '{print $2}'`
#CHAINPOINT_NODE_PUBLIC_URI=`cat ecs_instance_list_ap-southeast-1_2017-09-24.csv  | awk  '{print $10}'|sed "s/\"//g"|sed "s/.*/http:\/\/&/"`
CHAINPOINT_NODE_PUBLIC_URI=`ifconfig eth0 | grep "inet addr"|sed 's/inet addr:\(.*\) .*/\1/'|awk '{print $1}'|sed "s/.*/http:\/\/&/"`
IPADDR=`ifconfig eth0 | grep "inet addr"|sed 's/inet addr:\(.*\) .*/\1/'|awk '{print $1}'`
NODE_TNT_ADDRESS=`grep $IPADDR /tmp/ceshi.txt  | awk '{print $2}'`
apt-get update
sleep 1
sudo apt-get install apt-transport-https ca-certificates curl software-properties-common -y
if [ $? -eq 0 ];
then
	curl -sSL https://cdn.rawgit.com/chainpoint/chainpoint-node/13b0c1b5028c14776bf4459518755b2625ddba34/scripts/docker-install-ubuntu.sh | bash 
#	reboot
fi
sleep 1
#cd ~/chainpoint-node <<EOF
#cp .env.sample .env
#sed   -i 's/NODE_TNT_ADDRESS=/&'${NODE_TNT_ADDRESS}'/g' .env
#sleep 1
#sed   -i 's/CHAINPOINT_NODE_PUBLIC_URI=/&'${CHAINPOINT_NODE_PUBLIC_URI}'/g' .env
#sleep 1
#make up
#EOF

