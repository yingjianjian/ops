#!/bin/bash

LOGS_PATH=/usr/local/nginx/logs/

YESTERDAY=$(date -d "yesterday" +%Y%m%d)

#�����и���־

#��nginx�����̷���USR1�źţ����´���־�ļ�������������mv����ļ�д���ݵġ�ԭ�����ڣ�linuxϵͳ�У��ں��Ǹ����ļ������������ļ��ġ��������������������־�и�
ʧ�ܡ�
mv ${LOGS_PATH}/access.log ${LOGS_PATH}/access_${YESTERDAY}.log

kill -USR1 `ps axu | grep "nginx: master process" | grep -v grep | awk '{print $2}'`

#ɾ��7��ǰ����־

cd ${LOGS_PATH}

find . -mtime +7 -name "*20[1-9][3-9]*" | xargs rm -f

exit 0
