#!/bin/bash
appname=clms-front
hn=`hostname -f`
pid=`ps -ef | grep $appname| grep -v grep | awk '{print $2}'`
dir=/srv/logs
dumpfile=${hn}_`date +"%Y%m%d_%H%M%S"`

echo hn :$hn
echo appname :$appname
echo pid :$pid

jmap -dump:format=b,file=$dumpfile $pid && tar -zcf $dumpfile.tar.gz $dumpfile
