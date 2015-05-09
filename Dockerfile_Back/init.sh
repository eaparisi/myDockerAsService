#!/bin/bash

cp /root/pw.txt /root/pw_old.txt
echo $ROOTPASS > /root/pw.txt
echo "root:$(cat /root/pw.txt)" | chpasswd

sed -i "s/api.yeswead.local/$BACKDOMAIN/g" /etc/apache2/sites-available/myvhost_backend.conf
a2ensite myvhost_backend.conf

sed -i "s/backoffice.yeswead.local/$BACKOFFICEDOMAIN/g" /etc/apache2/sites-available/myvhost_backoffice.conf
a2ensite myvhost_backoffice.conf

sed -i "s/frontendyii.yeswead.local/$FRONTYIIDOMAIN/g" /etc/apache2/sites-available/myvhost_frontyii.conf
a2ensite myvhost_frontyii.conf

php5enmod mcrypt

service apache2 restart

service memcached start

cp /usr/share/zoneinfo/America/Buenos_Aires /etc/localtime

file="/var/www/backend/application/config/yeswead.php"
if [ ! -f "$file" ]
then
	rm $file
fi
cd /var/www/backend/application/config/
cp yeswead.tpl.php yeswead.php
chown 1000:1000 yeswead.php

sed -i "s/api.yeswead.local/$BACKDOMAIN/g" /var/www/backend/application/config/yeswead.php
sed -i "s/api.yeswead/$ADMINDOMAIN/g" /var/www/backend/application/config/yeswead.php
sed -i "s/yeswead.local/$FRONTDOMAIN/g" /var/www/backend/application/config/yeswead.php

sed -i "s/dbhost/$DBHOST/g" /var/www/backend/application/config/yeswead.php
sed -i "s/dbusername/$DBUSERNAME/g" /var/www/backend/application/config/yeswead.php
sed -i "s/dbpass/$DBPASS/g" /var/www/backend/application/config/yeswead.php
sed -i "s/dbname/$DBNAME/g" /var/www/backend/application/config/yeswead.php	

/usr/sbin/sshd -D &
wait ${!}
