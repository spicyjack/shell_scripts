# QEMU_TMPDIR is the ramdisk used for accelerating qemu
# this version is for running headless
# make sure you add 'console=ttyS0,9600' to your grub, and start a getty on
# ttyS0

# How to use QEMU under screen:
# 1) Install your operating system using a normal QEMU session, making sure to
# enable serial console everywhere (bootloader, kernel boot, inittab)
# 2) start screen.  a .screenrc profile with commonly run programs is optional
# 3) inside of screen, start QEMU.  use tbe below script as an example.  Make
# sure you use -nographic at the minimum, that will cause all output to go to
# the faux serial port
# 4) once the OS is up and running, log in
# 5) to give screen commands, use the double Ctrl-A sequence:
# ^a^aw will show you a list of open windows in screen
# 6) screen can take control of the ^a sequence, in which case the double
# Ctrl-A will stop working; in that case, use the screen ^a sequence first 
# (Ctrl-a a), then send the QEMU command after that

# QEMU console mode commands
# ^a ^a - send Ctrl-a to a program (including screen?)
# ^a x - exit the emulator
# ^a s - save snapshot data to disk
# ^a b - send magic sysrq (break key)
# ^a c - switch between console and monitor

# set a pidfile
PIDFILE=/home/virtual/etch_apachetest-x86/qemu.pid

# if you get errors when starting QEMU about 'kqemu' not being found, re-insert
# the kqemu kernel module: /sbin/modprobe kqemu major=250
# also make sure that /dev/kqemu is writeable by the same user that's running
# qemu

QEMU_TMPDIR=/home/virtual/ramdisk /usr/local/bin/qemu \
    -cdrom /home/ftp/linux/mirrors/debian/debian-31r4-i386-binary-1.iso \
    -pidfile $PIDFILE -monitor stdio \
    -m 256 -nographic -serial stdio \
    -boot c -localtime \
	-redir tcp:18080::8080 -redir tcp:18443::8443 \
	-redir tcp:10022::22 -redir tcp:10747::10747 \
    -redir tcp:17375::17375 -redir tcp:15282::15282 \
    -usb -usbdevice disk:demo0.qcow2 -usbdevice disk:demo1.qcow2 \
    -usbdevice disk:demo2.qcow2 -usbdevice disk:demo3.qcow2 \
    -usbdevice disk:demo4.qcow2 -usbdevice disk:demo5.qcow2 \
    -usbdevice tablet \
	-hda disk1.qcow2 

    #-vnc :0 -k en-us
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
