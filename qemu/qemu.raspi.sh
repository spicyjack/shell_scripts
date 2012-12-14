#!/bin/sh

#source common.cfg

/usr/local/bin/qemu-system-arm \
    -kernel kernel-qemu \
    -cpu arm1176 \
    -m 256 \
    -M versatilepb \
    -no-reboot \
    -localtime \
    -monitor stdio \
    -serial telnet::4444,server,nowait \
    -hda 2012-10-28-wheezy-raspbian.img \
    -hdb debian_wheezy_armhf.qcow2 \
    -append "root=/dev/sda2 panic=1" \

#    -redir tcp:29022::22 \
#    -redir tcp:29000::8000 \
#    -cdrom /Volumes/Raid/Users/brian/Files/ISOs/debian-testing-armhf-CD-1.iso \
#    -serial telnet::4444,server,nowait \
#    -vnc :1 -k en-us \
#    -initrd initrd.img-2.6.26-1-versatile \
#    -append "root=/dev/sda1"


# vim: set paste :
