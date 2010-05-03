qemu-system-mipsel \
    -M malta \
    -m 256 \
    -kernel vmlinux-2.6.26-2-4kc-malta \
    -initrd initrd-2.6.26-2.gz \
    -nographic \
    -hda disk1.qcow2 \
    -append "root=/dev/ram console=ttyS0"

