#!/bin/bash
set -ex

modprobe nbd max_part=1

qemu-nbd --connect=/dev/nbd0 build/root.qcow2
sleep 1

mount /dev/nbd0 rootfs

chroot rootfs sh -c "
    apt-get update \
    && apt-get install -y \
    ifupdown \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /var/cache/apt/
"

umount rootfs
qemu-nbd --disconnect /dev/nbd0

exit 0

qemu-system-x86_64 -machine q35,accel=kvm -cpu host -m 4G  -rtc clock=host -no-user-config -no-reboot -nographic \
 -kernel build/vmlinuz -initrd build/initrd.img -append "console=ttyS0 rootfstype=ext4 root=/dev/vda" \
 -netdev user,id=user0 -device virtio-net-pci,netdev=user0 \
 -drive id=root,file=build/root.qcow2,format=qcow2,if=none -device virtio-blk-pci,drive=root 