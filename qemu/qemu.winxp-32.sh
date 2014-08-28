PIDFILE=qemu.pid

/usr/local/bin/qemu-system-i386 \
    -m 1024 \
    -name winxp-32 \
    -pidfile $PIDFILE \
    -localtime \
    -monitor stdio \
    -vnc 127.0.0.1:1 \
    -k en-us \
    -usb \
    -usbdevice tablet \
    -netdev user,id=foonet0 \
    -device rtl8139,netdev=foonet0 \
    -redir tcp:13389::3389 \
    -redir tcp:13022::22 \
    -cdrom winxpsp2.iso \
    -boot order=cd,menu=on \
    -hda disk1.qcow2 \
    -hdb nbd+unix://?socket=${PWD}/winxp32-socket

# you can't use this if you background qemu, as the PID file will be removed
# as soon as the shell returns from backgrounding the qemu process
if [ $? -gt 0 ]; then
   echo "QEMU exited with status code of $?"
fi
rm $PIDFILE
