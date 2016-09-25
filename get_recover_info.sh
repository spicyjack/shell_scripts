#!/bin/bash

# dump recovery information to a text file
OUTPUT_FILE="/etc/recovery.txt"
echo "=-=-=-=-=-= Recovery info for $(cat /etc/hostname) =-=-=-=-=-=" \
    > $OUTPUT_FILE
/bin/echo >> $OUTPUT_FILE

# get a list of disks without a number at the end of the device name;
# this should grab all of the raw devices, without grabbing partitions on
# those devices as well
RAW_DISKS=$(/bin/cat /proc/diskstats | grep -v "0 0 0 0" \
    | awk '{print $3}' | grep -v '[0-9]$' | sort)
for DISK in $RAW_DISKS;
do
    echo "#### fdisk: ${DISK} ####" >> $OUTPUT_FILE
    /sbin/fdisk -l /dev/${DISK} >> $OUTPUT_FILE 2>&1
    /bin/echo >> $OUTPUT_FILE
done

echo "#### loopback mounts ####" >> $OUTPUT_FILE
/sbin/losetup -a >> $OUTPUT_FILE
/bin/echo >> $OUTPUT_FILE

echo "#### mounts ####" >> $OUTPUT_FILE
/bin/cat /proc/mounts >> $OUTPUT_FILE
/bin/echo >> $OUTPUT_FILE

echo "#### disk usage ####" >> $OUTPUT_FILE
/bin/df >> $OUTPUT_FILE
/bin/echo >> $OUTPUT_FILE

echo "#### network interfaces ####" >> $OUTPUT_FILE
/sbin/ifconfig >> $OUTPUT_FILE

echo "#### network routes ####" >> $OUTPUT_FILE
/sbin/route -n >> $OUTPUT_FILE
/bin/echo >> $OUTPUT_FILE

echo "#### package listing ####" >> $OUTPUT_FILE
#/usr/bin/dpkg -l >> $OUTPUT_FILE
cd /var/lib/dpkg/info/
/bin/ls *.list | /bin/sed 's/\.list//' >> $OUTPUT_FILE

