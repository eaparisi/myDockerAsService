#!/bin/bash

cp /root/pw.txt /root/pw_old.txt
echo $ROOTPASS > /root/pw.txt
echo "root:$(cat /root/pw.txt)" | chpasswd

a2ensite myvhost_frontend.conf
a2ensite myvhost_backend.conf
a2ensite myvhost_static.conf
a2ensite myvhost_backoffice.conf
a2ensite myvhost_frontyii.conf

php5enmod mcrypt

service apache2 restart

service memcached start

cp /usr/share/zoneinfo/America/Buenos_Aires /etc/localtime

/usr/sbin/sshd -D &
wait ${!}
