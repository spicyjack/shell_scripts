#!/bin/sh

/usr/local/bin/qemu-system-arm \
   -name RetroPie \
   -kernel kernel-qemu \
   -cpu arm1176 \
   -m 256 \
   -machine versatilepb \
   -no-reboot \
   -localtime \
   -monitor stdio \
   -serial telnet::31023,server,nowait \
   -append "root=/dev/sda2 panic=1 rootfstype=ext4 rw" \
   -net nic -net user,hostfwd=tcp::3122-:22,hostfwd=tcp::3180-:80 \
   -dtb bcm2709-rpi-2-b.dtb \
   -drive file=2016-11-25-raspbian-jessie-lite.img,index=0,media=disk,format=raw \

#   -kernel kernel7.img \
#   -machine raspi2 \
#   -append "root=/dev/mmcblk0p2 panic=1 rootfstype=ext4 rw init=/bin/bash" \
#   -net nic \
#   -net user,hostfwd=tcp::31022-:22 \
#   -net user,hostfwd=tcp::31080-:80 \
#   -net user,hostfwd=tcp::31443-:443

#   -append "root=/dev/sda2 panic=1 rootfstype=ext4 rw init=/bin/bash" \

# Raspberry Pi (boots): kernel-qemu
# Raspberry Pi (boots): kernel7.img
# Chromium image (works): chromium.zImage / chromium.rootfs.ext2
# ARM test image: zImage.integrator / arm_root.img
#    -redir tcp:29022::22 \
#    -redir tcp:29000::8000 \
#    -cdrom /Volumes/Raid/Users/brian/Files/ISOs/debian-testing-armhf-CD-1.iso \
#    -serial telnet::4444,server,nowait \
#    -vnc :1 -k en-us \
#    -initrd initrd.img-2.6.26-1-versatile \
#    -append "root=/dev/sda1"

# /usr/local/bin/qemu-system-arm \
# -name "Raspberry Pi Emulator" \
# -kernel kernel-qemu \
# -cpu arm1176 \
# -m 256 \
# -M versatilepb \
# -serial stdio \
# -append "root=/dev/sda2 panic=1 rootfstype=ext4 rw" \
# -drive file=2016-02-26-raspbian-jessie.img,index=0,media=disk,format=raw \
# -net nic \
# -net user,hostfwd=tcp::3122-:22,hostfwd=tcp::3180-:80

# vim: set paste :
