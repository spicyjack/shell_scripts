# QEMU_TMPDIR is the ramdisk used for accelerating qemu
# this version is for running headless
# make sure you add 'console=ttyS0,9600' to your grub, and start a getty on
# ttyS0
QEMU_BIN="/usr/local/bin/qemu"
PIDFILE=qemu-soekris.pid

$QEMU_BIN \
    -m 64 \
    -name soekris-demo \
    -pidfile $PIDFILE -monitor stdio \
    -nographic \
    -boot c -localtime \
    -hda soekris.qcow2 \
    -net nic,model=pcnet \
    -redir tcp:20022::22 \
    -redir tcp:24200::4200 \
    -serial telnet::24444,server,nodelay \
	-kernel vmlinuz.soekris \
	-initrd initramfs.soekris \
	-append "console=ttyS0,9600n8 init=/bin/busybox"
	#-append "ro console=ttyS0,9600n8 console=tty0 run=init DEBUG=1"
    #-cdrom /opt/www/html/ISOs/debian-LennyBeta2-i386/debian-LennyBeta2-i386-CD-1.iso\
	#-append "rootvol=rootvol volgrp=vg0 ro console=ttyS0,9600n8 console=tty0 run=init"
	#-append DEBUG=1

# you can't use this if you background qemu, as the PID file will be removed
# as soon as the shell returns from backgrounding the qemu process
if [ $? -gt 0 ]; then 
   echo "QEMU exited with status code of $?"
fi
rm $PIDFILE

#    -boot c -localtime -redir tcp:2222::22 disk1.img
# -boot 
# a == floppy
# c == hard drive
# d == cd rom
#    -monitor stdio -serial stdio \

# this version is for when you want a display
# CWD=$(pwd)

# $CWD/bin/qemu \
#    -cdrom $CWD/isos/debian-31r1a-i386-netinst.iso \
#    -pidfile $CWD/pids/$PIDFILE \
#    -boot c -localtime -redir tcp:2222::22 \
#	 $CWD/disks/debian.sarge.qcow
# make sure you add 'console=ttyS0,9600 console=tty0' to your grub, and start a
# getty on ttyS0

# vim: set paste :
