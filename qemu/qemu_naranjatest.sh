# QEMU_TMPDIR is the ramdisk used for accelerating qemu
# this version is for running headless
# make sure you add 'console=ttyS0,9600' to your grub, and start a getty on
# ttyS0
PIDFILE=qemu.pid

#QEMU_TMPDIR=/local/mnt/virtual/ramdisk
./qemu-i386-softmmu \
    -cdrom /Users/Shared/Files/ISOs/debian/debian-40r0-i386-CD-1.iso \
    -pidfile $PIDFILE \
    -monitor stdio \
    -m 192 \
    -boot c \
    -localtime \
    -soundhw es1370 \
    -net nic,model=ne2k_pci \
    -redir tcp:22222::22 \
	-usb \
	-hda Harddisk_1.qcow2 \
	-kernel vmlinuz-2.6.23.12-naranja \
	-initrd initramfs-2.6.23.12-naranja.2008.031.1.cpio.gz \
	-append "DEBUG=1 run=init"

#   -fda fat:floppy:/my_directory
#	-usbdevice disk:demo0.qcow 
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
