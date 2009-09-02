#!/bin/sh

# handle PID file, KERNEL_VER and other fun things
source ./qemu-cfgs/common.cfg

# project specific settings
source ./qemu-cfgs/$QEMU_CFG.cfg

# start QEMU using the supplied argments
$QEMU_BIN \
    -localtime \
    -m "$QEMU_MEM" \
    -name "$QEMU_CFG" \
    -pidfile $QEMU_PID \
    -monitor "$QEMU_MONITOR" \
    -boot "$QEMU_BOOT" \
    -serial telnet::4444,server,nowait \
    -soundhw "$QEMU_SOUNDHW" \
    -usb \
    -hda "$QEMU_HDA" \
    -kernel "$QEMU_KERNEL" \
    -initrd $1 \
    -append "$QEMU_APPEND" \
    $EXTRA_ARGS 

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

# vim: set paste ft=sh :
