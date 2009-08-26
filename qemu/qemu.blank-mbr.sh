#!/bin/sh

# handle PID file, KERNEL_VER and other fun things
source qemu-common.sh

#    -cdrom /Users/Shared/Files/ISOs/debian-LennyBeta2-i386-CD-1.iso \
$QEMU_BIN \
    -m 64 \
    -name "blank-mbr" \
    -pidfile $QEMU_PID -monitor stdio \
    -boot c -localtime \
	-usb \
    -hda blank-mbr.qcow2 \
	-kernel vmlinuz-$KERNEL_VER-antlinux \
	-initrd $1 \
	-append "console=ttyS0,9600n8 console=tty0 blankdev=/dev/hda confirm=n"
	#-append "console=ttyS0,9600n8 console=tty0 network=lo"
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
