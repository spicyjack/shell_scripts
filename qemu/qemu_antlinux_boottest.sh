#!/bin/sh

source qemu-common.sh

#    -cdrom /Users/Shared/Files/ISOs/debian-LennyBeta2-i386-CD-1.iso \
$QEMU_BIN \
    -m 160 \
    -name "propaganda tester" \
    -cdrom propaganda.2009.5.iso \
    -pidfile $QEMU_PID -monitor stdio \
    -boot c -localtime \
    -redir tcp:4200::4200 \
    -redir tcp:7767::7767 \
    -redir tcp:8001::8000 \
    -soundhw es1370 \
	-usb \
    -usbdevice disk:qotsa_flash_drive.qcow2 \
    -hda disk1.qcow2 \
	-kernel vmlinuz.propaganda \
	-initrd $1 \
	-append "console=ttyS0,9600n8 console=tty0 run=init pause=1"
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
