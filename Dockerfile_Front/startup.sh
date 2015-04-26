#!/bin/bash

cp /root/pw.txt /root/pw_old.txt
echo $ROOTPASS > /root/pw.txt
echo "root:$(cat /root/pw.txt)" | chpasswd

a2ensite myvhost_frontend.conf
a2ensite myvhost_backend.conf
a2ensite myvhost_static.conf

php5enmod mcrypt

service apache2 restart

cp /usr/share/zoneinfo/America/Buenos_Aires /etc/localtime

echo "127.0.0.1 yeswead.local www.yeswead.local cdn.yeswead.local localhost" >> /etc/hosts &&\
	echo "172.17.42.1 api.yeswead.local" >> /etc/hosts &&\
    echo yeswead > /etc/hostname

/usr/sbin/sshd -D &
wait ${!}