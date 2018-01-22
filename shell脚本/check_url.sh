#!/bin/bash
#
#      Filename: check_url.sh
#      yingjianjian
#        Author: Clough - clough@gmail.com
#   Description: ---
#        Create: 2017-04-23 20:15:54
# Last Modified: 2017-04-23 20:15:54
. /etc/init.d/functions
wait(){
	echo -n "Please wait for three seconds "
	for ((i=0;i<3;i++))
	do
		echo -n ".";sleep 1
	done
}

userlist=(
http://etiantian.org
http://www.linuxpeixun.com
http://oldboy.blog.51cto.com
)
check_url(){
	wait
	echo "\n"
	echo "check url ...."
	for ((i=0;i<${#userlist[@]};i++))
	do
	judge=($(curl -I -s --connect-timeout 2 ${userlist[$i]} |head -1 |tr "\r" "\n"))
	#judge=($(curl -I -s --connect-timeout 2 -o /dev/null  www.baidu.com -w "%{http_code}"))
	if [[ "${judge[1]}" == '200' &&  "${judge[2]}"=='OK' ]]
	then
		action "${userlist[$i]}" /bin/true
	else
		action "${userlist[$i]}" /bin/false
	fi
	done
}
check_url
