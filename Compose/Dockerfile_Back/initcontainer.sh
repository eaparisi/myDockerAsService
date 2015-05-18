#!/bin/bash

# -------------------- ROOT USER -----------------------------------------------------------------------------------

cp /root/pw.txt /root/pw_old.txt
echo $ROOTPASS > /root/pw.txt
echo "root:$(cat /root/pw.txt)" | chpasswd

# -------------------- APACHE --------------------------------------------------------------------------------------

# VIRTUALHOSTS
sed -i "s/api.yeswead.local/$BACKDOMAIN/g" /etc/apache2/sites-available/myvhost_backend.conf
sed -i "s/backoffice.yeswead.local/$BACKOFFICEDOMAIN/g" /etc/apache2/sites-available/myvhost_backoffice.conf
sed -i "s/frontendyii.yeswead.local/$FRONTYIIDOMAIN/g" /etc/apache2/sites-available/myvhost_frontyii.conf
sed -i "s/files.yeswead.local/$FILESDOMAIN/g" /etc/apache2/sites-available/myvhost_files.conf
a2ensite myvhost_backend.conf
a2ensite myvhost_backoffice.conf
a2ensite myvhost_frontyii.conf
a2ensite myvhost_files.conf

# MCRYPT
php5enmod mcrypt

service apache2 restart

# -------------------- MEMCACHE ------------------------------------------------------------------------------------

service memcached start

# -------------------- TIMEZONE ------------------------------------------------------------------------------------

cp /usr/share/zoneinfo/America/Buenos_Aires /etc/localtime

# -------------------- UPLOADS FOLDERS -----------------------------------------------------------------------------

uploadFolder="/var/www/backend/uploads"
if [ ! -d "$uploadFolder" ]; then
	mkdir $uploadFolder
	cd $uploadFolder
	mkdir bid_files
	mkdir profile_pictures
	mkdir project_files
	mkdir projects_follow
	cd ..
	chmod 777 uploads/ -R
fi

# -------------------- BACKEND ENVIRONMENT PARAMS (yeswead.php) ------------------------------------------------------

file="/var/www/backend/application/config/yeswead.php"
if [ ! -f "$file" ]; then
	rm $file
fi

cd /var/www/backend/application/config/
cp yeswead.tpl.php yeswead.php
chown 1000:1000 yeswead.php

sed -i "s/api.yeswead.local/$BACKDOMAIN/g" /var/www/backend/application/config/yeswead.php
sed -i "s/api.yeswead/$ADMINDOMAIN/g" /var/www/backend/application/config/yeswead.php
sed -i "s/yeswead.local/$FRONTDOMAIN/g" /var/www/backend/application/config/yeswead.php

sed -i "s/mailgunbool/$MAILGUNBOOL/g" /var/www/backend/application/config/yeswead.php
sed -i "s/mailprotocol/$MAILPROTOCOL/g" /var/www/backend/application/config/yeswead.php
sed -i "s/mailhost/$MAILHOST/g" /var/www/backend/application/config/yeswead.php
sed -i "s/mailuser/$MAILUSER/g" /var/www/backend/application/config/yeswead.php
sed -i "s/mailpass/$MAILPASS/g" /var/www/backend/application/config/yeswead.php
sed -i "s/mailport/$MAILPORT/g" /var/www/backend/application/config/yeswead.php

sed -i "s/dbhost/$DBHOST/g" /var/www/backend/application/config/yeswead.php
sed -i "s/dbusername/$DBUSERNAME/g" /var/www/backend/application/config/yeswead.php
sed -i "s/dbpass/$DBPASS/g" /var/www/backend/application/config/yeswead.php
sed -i "s/dbname/$DBNAME/g" /var/www/backend/application/config/yeswead.php	

# --------------------------------------------------------------------------------------------------------------------

/usr/sbin/sshd -D &
wait ${!}
