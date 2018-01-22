#!/bin/bash

snlist=$1
./get_oobip.sh $snlist > sniplist
pwd="9ijn0okm"

cat sniplist | while read line
do
  sn=`echo $line | awk '{print $1}'`
  ip=`echo $line | awk '{print $2}'`
  [[ "$ip" == "" ]] && (echo "no oob ip"; continue)
  ipmitool -I lanplus -H $ip -U taobao -P $pwd chassis bootdev pxe
  ipmitool -I lanplus -H $ip -U taobao -P $pwd power reset
  [[ $? -eq 0 ]] || echo "$sn $ip -> PXE fail"
done 
