#!/bin/sh

# handle PID file, KERNEL_VER and other fun things
source qemu-common.sh

$QEMU_BIN \
    -m 160 \
    -name "antlinux" \
    -pidfile $QEMU_PID \
    -monitor stdio \
    -boot c -localtime \
    -redir tcp:20022::22 \
    -redir tcp:28000::8000 \
    -redir tcp:4201::4200 \
    -usb \
    -hda disk1.qcow2 \
	-kernel vmlinuz-$KERNEL_VER-antlinux \
	-initrd $1 \
	-append "console=ttyS0,9600n8 console=tty0 loglevel=6 run=init"
    #-hdd fat:/media/disk/newrips/Cirith\ Ungol/King\ Of\ The\ Dead/ \
	#-append "console=ttyS0,9600n8 console=tty0 network=lo"
	#-append DEBUG=1

# you can't use this if you background qemu, as the PID file will be removed
# as soon as the shell returns from backgrounding the qemu process
if [ $? -gt 0 ]; then 
   echo "QEMU exited with status code of $?"
fi
rm $QEMU_PID

#    -boot c -localtime -redir tcp:2222::22 disk1.img
# -boot 
# a == floppy
# c == hard drive
# d == cd rom
#    -monitor stdio -serial stdio \

# vim: set paste :
