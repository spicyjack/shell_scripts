#/bin/bash

# Generate an ISO for mounting under QEMU
IMG_DATE=$(date +%Y.%j-%H%M)
hdiutil makehybrid \
   -o Apps_Disk.${IMG_DATE}.iso \
   Apps_ISO \
   -iso \
   -joliet
