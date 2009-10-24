#!/bin/sh

#source common.cfg

/usr/local/bin/qemu-system-arm \
    -m 192 \
    -name arm-demo \
    -M versatilepb \
    -cdrom /opt/www/html/ISOs/debian-503-arm-CD-1.iso \
    -pidfile qemu.pid \
    -serial telnet::4444,server,nowait \
    -monitor stdio \
    -boot d \
    -localtime \
    -soundhw all \
    -redir tcp:28022::22 \
    -redir tcp:28000::8000 \
    -redir tcp:28200::4200 \
    -hda debian_lenny_armel_small.qcow \
	-usb \
    -kernel vmlinuz-2.6.26-1-versatile \
    -initrd initrd.img-2.6.26-1-versatile \
    -append "root=/dev/sda1"

# vim: set paste :
