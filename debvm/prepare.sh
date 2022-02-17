#!/bin/bash
set -ex


PACKAGES="$(cat ../debian-packages.txt | tr -s '\n' ' ')"

docker build --build-arg MIRROR="http://mirror.kakao.com" -t debootstrap - < debootstrap.dockerfile

modprobe nbd max_part=1

rm -rf build
mkdir -p build
qemu-img create -f qcow2 build/root.qcow2 256G
qemu-nbd --connect=/dev/nbd0 build/root.qcow2
sleep 1
mkfs.ext4 /dev/nbd0

rm -rf rootfs
mkdir -p rootfs
mount /dev/nbd0 rootfs

echo "PACKAGES: ${PACKAGES}"

PACKAGES=""
docker run --privileged --rm -v${PWD}/rootfs:/data debootstrap
chroot rootfs sh -c "
    apt-get update \
    && apt-get install -y \
    linux-image-amd64 qemu-guest-agent e2fsprogs init systemd ifupdown ${PACKAGES} \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /var/cache/apt/
"

chroot rootfs sh -c "echo 'root:root' | chpasswd"
chroot rootfs systemctl enable serial-getty@ttyS0.service

mkdir -p rootfs/etc/network

echo "/dev/vda / ext4 errors=remount-ro,acl 0 1" > rootfs/etc/fstab

echo "
auto lo
iface lo inet loopback
auto eth0
iface eth0 inet dhcp
" >rootfs/etc/network/interfaces

echo "9pnet" >>rootfs/etc/modules
echo "9pnet_virtio" >>rootfs/etc/modules
echo "qemu_fw_cfg" >>rootfs/etc/modules
echo "virtio_console" >>rootfs/etc/modules

cp rootfs/boot/vmlinuz-* build/vmlinuz
cp rootfs/boot/initrd.img-* build/initrd.img

umount rootfs
qemu-nbd --disconnect /dev/nbd0

exit 0

qemu-system-x86_64 -machine q35,accel=kvm -cpu host -m 4G  -rtc clock=host -no-user-config -no-reboot -nographic \
 -kernel build/vmlinuz -initrd build/initrd.img -append "console=ttyS0 rootfstype=ext4 root=/dev/vda" \
 -netdev user,id=user0 -device virtio-net-pci,netdev=user0 \
 -drive id=root,file=build/root.qcow2,format=qcow2,if=none -device virtio-blk-pci,drive=root 