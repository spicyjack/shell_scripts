#!/bin/sh

# handle PID file, KERNEL_VER and other fun things
source qemu-common.sh

#    -cdrom /Users/Shared/Files/ISOs/debian-LennyBeta2-i386-CD-1.iso \
$QEMU_BIN \
    -m 160 \
    -name "propaganda tester" \
    -cdrom /opt/sourcecode/psas/propaganda.2009.5.iso \
    -pidfile $QEMU_PID \
    -serial telnet::4444,server,nowait \
    -monitor stdio \
    -boot c -localtime \
    -redir tcp:4201::4200 \
    -redir tcp:7768::7767 \
    -redir tcp:8001::8000 \
    -soundhw all \
	-usb \
    -hdd fat:/media/disk/newrips/Cirith\ Ungol/King\ Of\ The\ Dead/ \
    -hda disk1.qcow2 \
	-kernel vmlinuz-$KERNEL_VER-antlinux \
	-initrd $1 \
	-append "console=ttyS0,9600n8 console=tty0 run=init"
	#-append "console=ttyS0,9600n8 console=tty0 network=lo"
	#-append DEBUG=1
    #-usbdevice disk:qotsa_flash_drive.qcow2 \

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
