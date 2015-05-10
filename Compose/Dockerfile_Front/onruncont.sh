#!/bin/bash

cp /root/pw.txt /root/pw_old.txt
echo $ROOTPASS > /root/pw.txt
echo "root:$(cat /root/pw.txt)" | chpasswd

sed -i "s/ServerName          yeswead.local/ServerName          $FRONTDOMAIN/g" /etc/apache2/sites-available/myvhost_frontend.conf
sed -i "s/ServerAlias         www.yeswead.local/ServerAlias         $SERVERALIAS/g" /etc/apache2/sites-available/myvhost_frontend.conf
a2ensite myvhost_frontend.conf

php5enmod mcrypt

service apache2 restart

cp /usr/share/zoneinfo/America/Buenos_Aires /etc/localtime

echo "127.0.0.1 $FRONTDOMAIN www.$FRONTDOMAIN cdn.$FRONTDOMAIN localhost" >> /etc/hosts &&\
	echo "172.17.42.1 $BACKAPIDOMAIN" >> /etc/hosts

file="/var/www/frontend/config/generalconf.php"
if [ -f "$file" ]
then
	rm $file
fi
cd /var/www/frontend/config/
cp generalconf.tpl.php generalconf.php
chown 1000:1000 generalconf.php
sed -i "s/api.yeswead.local/$BACKAPIURL/g" /var/www/frontend/config/generalconf.php
sed -i "s/files.yeswead.local/$FILESDOMAIN/g" /var/www/frontend/config/generalconf.php
sed -i "s/\/yeswead.local/\/$SITEURL/g" /var/www/frontend/config/generalconf.php	
sed -i "s/yeswead.local/$FRONTDOMAIN/g" /var/www/frontend/config/generalconf.php

/usr/sbin/sshd -D &
wait ${!}
