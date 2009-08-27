# QEMU_TMPDIR is the ramdisk used for accelerating qemu
# this version is for running headless
# make sure you add 'console=ttyS0,9600' to your grub, and start a getty on
# ttyS0
#QEMU_BIN="/Applications/Apps/Q-0.9.0.app/Contents/MacOS/i386-softmmu.app/Contents/MacOS/i386-softmmu"
QEMU_BIN="/usr/local/bin/qemu"
PIDFILE=qemu.pid

# NOTE! -cdrom uses the secondary master channel (/dev/hdc)
$QEMU_BIN \
    -name "SimCity 2000" \
    -pidfile $PIDFILE -monitor stdio \
    -m 64 \
    -boot c -localtime \
    -soundhw adlib \
	-usb \
	-hda simcity2000.qcow2 \
    -hdb fat:/opt/www/html/idGames/doom
    -cdrom /opt/www/html/ISOs/freedos-1.0-full.iso

#-redir tcp:22222::22 \

# you can't use this if you background qemu, as the PID file will be removed
# as soon as the shell returns from backgrounding the qemu process
if [ $? -gt 0 ]; then 
   echo "QEMU exited with status code of $?"
fi
#rm $PIDFILE

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
