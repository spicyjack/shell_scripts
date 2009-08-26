#!/bin/sh

# handle PID file, KERNEL_VER and other fun things
source qemu-common.sh

$QEMU_BIN \
    -m 64 \
    -name soekris-demo \
    -pidfile $QEMU_PID -monitor stdio \
    -boot c -localtime \
    -hda soekris.qcow2 \
    -net nic,model=pcnet \
    -redir tcp:20022::22 \
    -redir tcp:24200::4200 \
    -serial telnet::24444,server,nodelay \
	-kernel vmlinuz-$KERNEL_VER-elan \
	-initrd $1 \
	-append "console=ttyS0,9600n8 console=tty0 run=init"
    #-append "console=ttyS0,9600n8 init=/bin/busybox"
	#-append "ro console=ttyS0,9600n8 console=tty0 run=init DEBUG=1"

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
