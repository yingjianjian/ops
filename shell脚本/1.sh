#!/bin/bash
#
#      Filename: 1.sh
#      yingjianjian
#        Author: Clough - clough@gmail.com
#   Description: ---
#        Create: 2017-04-19 15:01:55
# Last Modified: 2017-04-19 15:01:550
RETVAL=0
SCRIPTS_PATH="/server/scripts"
MAIL_GROUP="429795337@qq.com"
LOG_FILE="/tmp/web_check.log"
FAILCOUNT=0
function Get_Url_Status(){
for (( i=1;i<=3;i++))
 do		
   wget -T 10 --tries=1 --spider http://${1} >/dev/null 2>&1 
   [ $? -ne 0 ] && let FAILCOUNT+=1
 done
 if [ $FAILCOUNT -gt 1 ];then
   RETVAL=1
   NowTime=`date +"%m-%d %H:%M:%S"`
   SUBJECT_COUNTENT="http://${1}service is error,${NowTime}"
   for MAIL_USER in $MAIL_GROUP 
    do
     mail -s "$SUBJECT_COUNTENT " $MAIL_USER<$LOG_FILE
    done
   echo "send to : $MAIL_USER,Title:$SUBJECT_COUNTENT" >$LOG_FILE
   else
   RETVAL=0
   fi
   return $RETVAL
}
[ ! -d "$SCRIPTS_PATH" ] && mkdir -p $SCRIPTS_PATH
[ ! -f "$SCRIPTS_PATH/domain.list" ] && {
cat >$SCRIPTS_PATH/domain.list<<EOF
oldboy.blog.51cto.com
bbs.etiantian.org
EOF
}
for HOST_NAME in `cat $SCRIPTS_PATH/domain.list`
  do
    echo -n "checking $HOST_NAME:"
    Get_Url_Status $HOST_NAME && echo ok||echo no
  done
