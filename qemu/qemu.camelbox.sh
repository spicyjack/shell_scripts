# QEMU_TMPDIR is the ramdisk used for accelerating qemu
# this version is for running headless
# make sure you add 'console=ttyS0,9600' to your grub, and start a getty on
# ttyS0
PIDFILE=qemu.pid

# if you get errors when starting QEMU about 'kqemu' not being found, re-insert
# the kqemu kernel module: /sbin/modprobe kqemu major=250
# also make sure that /dev/kqemu is writeable by the same user that's running
# qemu
#    -nographic \

/usr/local/bin/qemu \
    -m 512 \
    -name camelbox \
    -pidfile $PIDFILE \
    -localtime \
    -monitor stdio \
    -vnc :1 \
    -usbdevice tablet \
    -soundhw all \
    -cdrom /net/nob/home/ftp/other/isos/wintools_cd/winxpsp2.iso \
    -boot d \
	-hda disk1.qcow2

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
