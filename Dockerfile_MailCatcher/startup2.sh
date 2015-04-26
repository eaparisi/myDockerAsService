#!/bin/bash

cp /root/pw.txt /root/pw_old.txt
echo $ROOTPASS > /root/pw.txt
echo "root:$(cat /root/pw.txt)" | chpasswd

mailcatcher --smtp-port 25 --ip `ip addr show dev eth0 scope global | grep inet | awk '{print $2;}' | cut -d/ -f1`

/usr/sbin/sshd -D &
wait ${!}
