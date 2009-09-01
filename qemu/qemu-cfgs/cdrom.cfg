#!/bin/sh

source qemu-common.sh

$QEMU_BIN \
    -m 192 \
    -name cdrom-demo \
    -cdrom $1 \
    -hda blank-mbr.qcow2 \
    -pidfile $QEMU_PID \
    -serial telnet::4444,server,nowait \
    -monitor stdio \
    -boot d -localtime \
    -soundhw all \
    -redir tcp:28022::22 \
    -redir tcp:28000::8000 \
    -redir tcp:28200::4200 \
	-usb 
    #-serial tcp::4444,server
	#-append "ro console=ttyS0,9600n8 console=tty0 run=init pause=1 DEBUG=1"
	#-append "ro console=ttyS0,9600n8 console=tty0 run=sh"
    #-cdrom /opt/www/html/ISOs/debian-LennyBeta2-i386/debian-LennyBeta2-i386-CD-1.iso\
	#-append "rootvol=rootvol volgrp=vg0 ro console=ttyS0,9600n8 console=tty0 run=init"
	#-append DEBUG=1

# you can't use this if you background qemu, as the PID file will be removed
# as soon as the shell returns from backgrounding the qemu process
if [ $? -gt 0 ]; then 
   echo "QEMU exited with status code of $?"
fi
rm $QEMU_PID

# a == floppy
# c == hard drive
# d == cd rom
#    -monitor stdio -serial stdio \

# vim: set paste :
