#!/bin/sh
qemu-system-ppc \
    -bios /usr/local/share/qemu/openbios-ppc \
    -cpu G4 \
    -M mac99 \
    -m 512 \
    -name ppc-base \
    -pidfile ppc-base.pid \
    -serial telnet::4444,server,nowait \
    -localtime \
    -vnc 127.0.0.1:1 \
    -usbdevice tablet \
    -monitor stdio \
    -redir tcp:28022::22 \
    -redir tcp:28000::8000 \
    -redir tcp:28200::4200 \
    -soundhw es1370 \
    -usb \
    -boot order=cd,once=d,menu=on \
    -prom-env 'boot-args=-v' \
    -hda ppc_disk.qcow2 \
    -cdrom /Users/Shared/Files/ISOs/debian-7.6.0-powerpc-CD-1.iso


#    -append "root=/dev/mapper/mips_builder-root console=ttyS0"
#    -cpu 7447A \
#    -M mac99 \
#    -M g3beige \
#    -kernel vmlinux-2.6.26-2-4kc-malta \
#    -initrd initrd-2.6.26-2.gz \
#    -monitor stdio \
# for use when installing the system

# vim: set paste :
