#!/bin/sh
qemu-system-mipsel \
    -M malta \
    -m 256 \
    -name mips-test \
    -kernel vmlinux-2.6.26-2-4kc-malta \
    -initrd initrd-2.6.26-2.gz \
    -pidfile mips-test.pid \
    -serial telnet::4444,server,nowait \
    -nographic \
    -boot d \
    -localtime \
    -redir tcp:28022::22 \
    -redir tcp:28000::8000 \
    -redir tcp:28200::4200 \
    -soundhw all \
	-usb \
    -hda disk1.qcow2 \
    -append "root=/dev/mapper/mips_builder-root console=ttyS0"

#    -monitor stdio \
# for use when installing the system

# vim: set paste :
