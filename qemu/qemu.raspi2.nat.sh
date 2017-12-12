#!/bin/sh
IMG_FILE="2017-11-29-raspbian-stretch-lite.img"

# what are we appending to the Linux boot command line?
BOOT_APPEND="rw earlyprintk loglevel=8 dwc_otg.lpm_enable=0"
BOOT_APPEND="${BOOT_APPEND} panic=1 console=ttyAMA0,115200 console=tty0"
#BOOT_APPEND="${BOOT_APPEND} panic=1 console=tty0 console=ttyAMA0,115200"
BOOT_APPEND="${BOOT_APPEND} root=/dev/mmcblk0p2 rootfstype=ext4 rw"
BOOT_APPEND="${BOOT_APPEND} rootwait"
#BOOT_APPEND="${BOOT_APPEND} rootwait init=/bin/bash"

# network port forwarding
HOST_FWDS="hostfwd=tcp::5022-:22"
HOST_FWDS="${HOST_FWDS},hostfwd=tcp::5080-:80"
HOST_FWDS="${HOST_FWDS},hostfwd=tcp::5443-:443"

/usr/local/bin/qemu-system-arm \
  -name raspi2 \
  -kernel kernel7.img \
  -dtb bcm2709-rpi-2-b.dtb \
  -machine raspi2 \
  -cpu arm1176 \
  -m 1G \
  -smp 4 \
  -no-reboot \
  -localtime \
  -monitor stdio \
  -serial telnet::5023,server,nowait \
  -net nic \
  -net user,${HOST_FWDS} \
  -drive file=${IMG_FILE},if=sd,format=raw \
  -usb \
  -usbdevice mouse -usbdevice keyboard \
  -append "${BOOT_APPEND}"
#  -device usb-mouse,bus=usb-bus.0 \
#  -device usb-keyboard,bus=usb-bus.0 \


#  -drive if=none,id=swap_stick,file=swap_disk.img,format=raw \
#  -device nec-usb-xhci,id=xhci \
#  -device usb-storage,bus=xhci.0,drive=swap_stick \


#  -drive file=transfer_disk.img,media=disk,format=raw \
# Run bash as 'init'
#  -append "root=/dev/sda2 panic=1 rootfstype=ext4 rw init=/bin/bash" \

# vim: set filetype=sh shiftwidth=2 tabstop=2 :
