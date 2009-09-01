#!/bin/sh

# handle PID file, KERNEL_VER and other fun things
source qemu-common.sh

#    -cdrom /Users/Shared/Files/ISOs/debian-LennyBeta2-i386-CD-1.iso \
$QEMU_BIN \
    -m 128 \
    -name "psas-player" \
    -pidfile $QEMU_PID \
    -serial telnet::4444,server,nowait \
    -monitor stdio \
    -boot c -localtime \
    -redir tcp:4200::4200 \
    -soundhw all \
	-usb \
    -hda disk1.qcow2 \
	-kernel vmlinuz-$KERNEL_VER-antlinux \
	-initrd $1 \
	-append "console=ttyS0,9600n8 console=tty0 loglevel=5 run=init mute=1"
    # for more dish on loglevel, see 
    # $KERNEL_SRC/Documentation/kernel-parameters.txt
	#-append "console=ttyS0,9600n8 console=tty0 run=init pause=1"
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
