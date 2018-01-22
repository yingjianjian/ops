#!/bin/bash
clear
echo "======================================================"
echo "========================lnmp=========================="
echo ""
echo "mysql dir:/usr/local/mysql"
echo "php   dir:/usr/local/php"
echo "nginx dir:/usr/local/nginx"
echo "web   dir:/usr/local/www"
echo ""
echo "====================lnmp-install======================"
echo "======================================================"
get_char(){
SAVEDSTTY=`stty -g`
stty -echo
stty cbreak
dd if=/dev/tty bs=1 count=1 2>/dev/null
stty -raw
stty echo
stty $SAVEDSTTY
}
echo ""
echo "Press any key to start..."
char=`get_char`
echo "=====================yum-install======================"
yum -y install  libjpeg libjpeg-devel
yum -y install patch make gcc gcc-c++ gcc-g77 flex bison
yum -y install libtool libtool-libs autoconf kernel-devel
yum -y install libjpeg libjpeg-devel libpng libpng-devel
yum -y install freetype freetype-devel libxml2 libxml2-devel zlib zlib-devel
yum -y install glib2 glib2-devel bzip2
yum -y install bzip2-devel ncurses ncurses-devel curl curl-devel e2fsprogs
yum -y install e2fsprogs-devel krb5 krb5-devel libidn libidn-devel
yum -y install openssl openssl-devel vim-minimal sendmail
yum -y install fonts-chinese scim-chewing scim-pinyin scim-tables-chinese
yum -y install pcre-devel
yum -y install net-snmp-devel
echo "=====================install finished================="
if [ -e "/usr/local/lnmp/libiconv-1.13" ]
then
echo "libiconv is already"
else
wget http://soft.vpser.net/web/libiconv/libiconv-1.13.tar.gz -P /usr/local/lnmp/ &&
cd /usr/local/lnmp/ &&
tar xzvf libiconv-1.13.tar.gz && 
cd libiconv-1.13 &&
./configure --prefix=/usr/local/ &&
make && make install
fi
if [ -e "/usr/local/lnmp/mhash-0.9.9.9" ]
then
echo "mhash in already"
else
wget http://soft.vpser.net/web/mhash/mhash-0.9.9.9.tar.gz -P /usr/local/lnmp/ &&
cd /usr/local/lnmp/ &&
tar xzvf mhash-0.9.9.9.tar.gz &&
cd mhash-0.9.9.9 &&
./configure --prefix=/usr/local/ &&
make && make install
fi
if [ -e "/usr/local/lnmp/libmcrypt-2.5.8" ]
then 
echo "libmcrypt is already"
else
wget  http://soft.vpser.net/web/libmcrypt/libmcrypt-2.5.8.tar.gz -P /usr/local/lnmp/ &&
cd /usr/local/lnmp/ &&
tar -xzvf libmcrypt-2.5.8.tar.gz &&
cd libmcrypt-2.5.8 &&
./configure &&
make && make install 
fi
ln -s /usr/local/lib/libmcrypt.la /usr/lib/libmcrypt.la
ln -s /usr/local/lib/libmcrypt.so /usr/lib/libmcrypt.so
ln -s /usr/local/lib/libmcrypt.so.4 /usr/lib/libmcrypt.so.4
ln -s /usr/local/lib/libmcrypt.so.4.4.8 /usr/lib/libmcrypt.so.4.4.8
ln -s /usr/local/lib/libmhash.a /usr/lib/libmhash.a
ln -s /usr/local/lib/libmhash.la /usr/lib/libmhash.la
ln -s /usr/local/lib/libmhash.so /usr/lib/libmhash.so
ln -s /usr/local/lib/libmhash.so.2 /usr/lib/libmhash.so.2
ln -s /usr/local/lib/libmhash.so.2.0.1 /usr/lib/libmhash.so.2.0.1
ln -s /usr/lib64/libjpeg.so /usr/lib/libjpeg.so
ln -s /usr/lib64/libpng.so /usr/lib/libpng.so
ln -s /usr/local/lib/libiconv.so.2 /usr/lib64/

echo "===================mysql-install================="
if [ -e "/usr/local/mysql" ]
then
echo "mysql is already"
else
wget http://soft.vpser.net/web/mcrypt/mcrypt-2.6.8.tar.gz -P /usr/local/lnmp/ &&
cd /usr/local/lnmp/ &&
tar -xzvf mcrypt-2.6.8.tar.gz  &&
cd mcrypt-2.6.8 &&
/sbin/ldconfig &&
./configure &&
make && make install 
groupadd mysql 
useradd mysql -g mysql
wget http://soft.vpser.net/datebase/mysql/mysql-5.1.35.tar.gz -P /usr/local/lnmp/ &&
cd /usr/local/lnmp/ &&
tar -xzvf mysql-5.1.35.tar.gz &&
cd mysql-5.1.35 &&
./configure --prefix=/usr/local/mysql --enable-assembler --with-charset=utf8 --enable-thread-safe-client --with-extra-charsets=all --without-isam &&
make && make install 
/usr/local/mysql/bin/mysql_install_db --user=mysql
cd  /usr/local/lnmp/mysql-5.1.35/support-files
cp mysql.server /etc/init.d/mysql
/bin/cp -r -f my-medium.cnf /etc/my.cnf 
chmod 755 /etc/init.d/mysql
cd /usr/local/mysql
chown -R mysql . 
chown -R mysql var 
chgrp -R mysql .  
/usr/local/mysql/bin/mysqld_safe --user=mysql &
/usr/local/mysql/bin/mysqladmin -u root password 'admin'
fi
echo "==================mysql-finshed================="
echo "===================php-install=================="
if [ -e "/usr/local/php" ]
then
echo "php is already"
else
wget http://mirrors.sohu.com/php/php-5.4.29.tar.gz -P /usr/local/lnmp/ &&
cd /usr/local/lnmp &&
tar zxvf php-5.4.29.tar.gz &&
cd php-5.4.29 &&
./configure --prefix=/usr/local/php  --enable-fpm --with-mcrypt --enable-mbstring --disable-pdo --with-curl --disable-debug  --disable-rpath --enable-inline-optimization --with-bz2  --with-zlib --enable-sockets --enable-sysvsem --enable-sysvshm --enable-pcntl --enable-mbregex --with-mhash --enable-zip --with-pcre-regex --with-mysql=/usr/local/mysql/ --with-mysqli=/usr/local/mysql/bin/mysql_config --with-gd --with-jpeg-dir --with-openssl  --with-freetype-dir  --enable-bcmath --enable-soap --with-gettext &&
sed  -i 's/.*-lcrypt$/& -liconv/'  Makefile &&
make && make install
cd /usr/local/lnmp/php-5.4.29
cp php.ini-development  /usr/local/php/lib/php.ini
cd /usr/local/php/etc/
mv  php-fpm.conf.default  php-fpm.conf
sed -i 's/^;pid/pid/' php-fpm.conf
sed -i "s/^user = nobody/user = www/" /usr/local/php/etc/php-fpm.conf 
sed -i "s/^group = nobody/group = www/" /usr/local/php/etc/php-fpm.conf 
/usr/local/php/sbin/php-fpm
fi
echo "==================php-finshed===================="
echo "==================nginx=install=================="
if [ -e "/usr/local/nginx" ]
then
echo "nginx in already"
else
useradd www
wget http://soft.vpser.net/web/nginx/nginx-0.7.61.tar.gz -P /usr/local/lnmp/ &&
cd /usr/local/lnmp
tar zxvf nginx-0.7.61.tar.gz  &&
cd nginx-0.7.61
./configure --user=www --group=www --prefix=/usr/local/nginx --with-http_stub_status_module --with-http_ssl_module
make && make install
sed -i  "64 a\location ~ \\.php$ { \n\troot           /usr/local/nginx/html;\n\tfastcgi_pass   127.0.0.1:9000;\n\tfastcgi_index  index.php;\n\tfastcgi_param  SCRIPT_FILENAME  \$document_root\$fastcgi_script_name;\n\tinclude        fastcgi_params;\n}" /usr/local/nginx/conf/nginx.conf 
chown -R www:www /usr/local/nginx/html/ 
chmod -R 700 /usr/local/nginx/html/ 
/usr/local/nginx/sbin/nginx
#cat >/usr/local/nginx/www/html/phpinfo.php<<eof<?phpinfo();?>eof
fi
echo "==================ngins-finshed=================="
