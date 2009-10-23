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
    -hda disk1.arm.qcow2 \
	-usb \
    -kernel vmlinuz-2.6.18-6-versatile \
    -initrd initrd.img-2.6.18-6-versatile \
    -append "root=/dev/ram"

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
