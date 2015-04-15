#!/bin/bash

cp /root/pw.txt /root/pw_old.txt
echo $ROOTPASS > /root/pw.txt
echo "root:$(cat /root/pw.txt)" | chpasswd

sed -i "s/desa.com.ar/$MYDOMAIN/g" /etc/apache2/sites-available/myvhost.conf
sed -i "s/basic/$MYWEBROOT/g" /etc/apache2/sites-available/myvhost.conf

a2ensite myvhost.conf

php5enmod mcrypt

service apache2 restart

cp /usr/share/zoneinfo/America/Buenos_Aires /etc/localtime

/usr/sbin/sshd -D &
wait ${!}
