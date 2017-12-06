#!/bin/sh
IMG_FILE="2017-11-29-raspbian-stretch-lite.img"

HOST_FWDS="hostfwd=tcp::4022-:22"
HOST_FWDS="${HOST_FWDS},hostfwd=tcp::4080-:80"
HOST_FWDS="${HOST_FWDS},hostfwd=tcp::4443-:443"

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
  -net nic \
  -net user,${HOST_FWDS} \
  -drive file=${IMG_FILE},media=disk,format=raw \
  -drive file=swap_disk.img,media=disk,format=raw \
  -drive file=transfer_disk.img,media=disk,format=raw \
  -append "root=/dev/sda2 panic=1 rootfstype=ext4 rw" \

# Run bash as 'init'
#  -append "root=/dev/sda2 panic=1 rootfstype=ext4 rw init=/bin/bash" \

# vim: set filetype=sh shiftwidth=2 tabstop=2 :
