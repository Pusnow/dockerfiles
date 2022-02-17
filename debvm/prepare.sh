#!/bin/bash
set -ex

PACKAGES="$(cat ../debian-packages.txt | tr -s '\n' ' ')"

docker build --build-arg MIRROR="http://mirror.kakao.com" -t debootstrap - <debootstrap.dockerfile

modprobe nbd max_part=1

rm -rf build
mkdir -p build
qemu-img create -f qcow2 build/rootfs.qcow2 256G
qemu-nbd --connect=/dev/nbd0 build/rootfs.qcow2 --cache=unsafe --discard=unmap
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
    linux-image-amd64 qemu-guest-agent e2fsprogs init systemd locales ifupdown ssh ca-certificates wget ${PACKAGES} \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /var/cache/apt/
"
mkdir -p rootfs/etc/network

mkdir -p rootfs/root
mkdir -p rootfs/sshd
mkdir -p rootfs/opt/vm

cp gh-init.sh rootfs/opt/vm/
cp vm-init.sh rootfs/opt/vm/
chown -R root:root rootfs/opt/vm/

cp gh-init.service rootfs/etc/systemd/system/
cp vm-init.service rootfs/etc/systemd/system/

chown root:root rootfs/etc/systemd/system/gh-init.service
chown root:root rootfs/etc/systemd/system/vm-init.service

chroot rootfs sh -c "echo 'root:root' | chpasswd"
chroot rootfs systemctl enable serial-getty@ttyS0.service
chroot rootfs systemctl enable qemu-guest-agent.service
chroot rootfs systemctl enable vm-init.service
chroot rootfs systemctl enable gh-init.service



echo "/dev/vda / ext4 errors=remount-ro,acl 0 1" >rootfs/etc/fstab

echo "
auto lo
iface lo inet loopback
auto eth0
iface eth0 inet dhcp
" >rootfs/etc/network/interfaces

sed -i 's/#PasswordAuthentication yes/PasswordAuthentication no/g' rootfs/etc/ssh/sshd_config
echo "HostKey /sshd/host_key" >>rootfs/etc/ssh/sshd_config
echo "en_US.UTF-8 UTF-8" > rootfs/etc/locale.gen
chroot rootfs locale-gen

chroot rootfs ln -snf /usr/share/zoneinfo/Asia/Seoul/etc/localtime 
echo Asia/Seoul> rootfs/etc/timezone



echo "qemu_fw_cfg" >>rootfs/etc/modules
echo "virtio_console" >>rootfs/etc/modules

cp rootfs/boot/vmlinuz-* build/vmlinuz
cp rootfs/boot/initrd.img-* build/initrd.img

umount rootfs
qemu-nbd --disconnect /dev/nbd0

exit 0

qemu-system-x86_64 -machine q35,accel=kvm -cpu host -m 4G -rtc clock=host -no-user-config -no-reboot -nographic \
    -kernel build/vmlinuz -initrd build/initrd.img -append "console=ttyS0 rootfstype=ext4 root=/dev/vda net.ifnames=0" \
    -device virtio-serial-pci \
    -chardev socket,path=/var/run/dinv-qga.sock,server=on,wait=off,id=qga0 \
    -device virtserialport,chardev=qga0,name=org.qemu.guest_agent.0 \
    -device virtio-balloon-pci \
    -netdev user,id=user0 -device virtio-net-pci,netdev=user0 \
    -drive id=root,file=build/rootfs.qcow2,format=qcow2,if=none -device virtio-blk-pci,drive=root
