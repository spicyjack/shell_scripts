#!/bin/bash

# dump recovery information to a text file

echo "#### fdisk ####" > /etc/recovery.txt
/sbin/fdisk -l /dev/sda >> /etc/recovery.txt
/bin/echo >> /etc/recovery.txt

echo "#### disk usage ####" >> /etc/recovery.txt
/bin/df >> /etc/recovery.txt
/bin/echo >> /etc/recovery.txt

echo "#### network information ####" >> /etc/recovery.txt
/sbin/ifconfig >> /etc/recovery.txt
/bin/echo >> /etc/recovery.txt
/sbin/route -n >> /etc/recovery.txt
/bin/echo >> /etc/recovery.txt

echo "#### package listing ####" >> /etc/recovery.txt
#/usr/bin/dpkg -l >> /etc/recovery.txt
cd /var/lib/dpkg/info/
/bin/ls *.list | /bin/sed 's/\.list//' >> /etc/recovery.txt

