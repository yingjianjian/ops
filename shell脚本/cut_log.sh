#!/bin/bash

LOGS_PATH=/usr/local/nginx/logs/

YESTERDAY=$(date -d "yesterday" +%Y%m%d)

#按天切割日志

#向nginx主进程发送USR1信号，重新打开日志文件，否则会继续往mv后的文件写数据的。原因在于：linux系统中，内核是根据文件描述符来找文件的。如果不这样操作导致日志切割
失败。
mv ${LOGS_PATH}/access.log ${LOGS_PATH}/access_${YESTERDAY}.log

kill -USR1 `ps axu | grep "nginx: master process" | grep -v grep | awk '{print $2}'`

#删除7天前的日志

cd ${LOGS_PATH}

find . -mtime +7 -name "*20[1-9][3-9]*" | xargs rm -f

exit 0
