#! /bin/sh
#释放Slab占用的cache内存空间
used=`free -m | awk 'NR==2' | awk '{print $3}'`
free=`free -m | awk 'NR==2' | awk '{print $4}'`
echo "===========================" >> /var/log/mem.log
date >> /var/log/mem.log
echo "Memory usage before | [Use：${used}MB][Free：${free}MB]" >> /var/log/mem.log
if [ $free -le 1000 ] ; then
                sync && echo 1 > /proc/sys/vm/drop_caches
                sync && echo 2 > /proc/sys/vm/drop_caches
                sync && echo 3 > /proc/sys/vm/drop_caches
                used_ok=`free -m | awk 'NR==2' | awk '{print $3}'`
                free_ok=`free -m | awk 'NR==2' | awk '{print $4}'`
                echo "Memory usage after | [Use：${used_ok}MB][Free：${free_ok}MB]" >> /var/log/mem.log
                echo "OK" >> /var/log/mem.log
else
                echo "Not required" >> /var/log/mem.log
fi
exit 1

touch /var/log/mem.log
chmod 755 free.sh
*/1 * * * * /usr/local/shell/free.sh