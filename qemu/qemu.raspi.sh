#!/bin/sh
IMG_FILE="2017-11-29-raspbian-stretch-lite.img"

/usr/local/bin/qemu-system-arm \
    -name raspi \
    -kernel kernel-qemu-4.4.34-jessie \
    -cpu arm1176 \
    -m 256 \
    -M versatilepb \
    -no-reboot \
    -localtime \
    -monitor stdio \
    -serial telnet::4023,server,nowait \
    -net user,hostfwd=tcp::4022-:22 \
    -net user,hostfwd=tcp::4080-:80 \
    -net user,hostfwd=tcp::4443-:443 \
    -drive file=${IMG_FILE},media=disk,format=raw \
    -drive file=transfer_disk.img,media=disk,format=raw \
    -append "root=/dev/sda2 panic=1 rootfstype=ext4 rw" \

#    -append "root=/dev/sda2 panic=1 rootfstype=ext4 rw init=/bin/bash" \

# vim: set filetype=sh shiftwidth=2 tabstop=2 paste :
