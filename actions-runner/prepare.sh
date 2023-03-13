#!/bin/bash
set -ex

sudo apt update && sudo apt install -y qemu-utils cloud-guest-utils

wget -O main.qcow2 https://cloud.debian.org/images/cloud/bullseye/latest/debian-11-genericcloud-amd64.qcow2

qemu-img resize main.qcow2 128G

sudo modprobe nbd max_part=8
sudo qemu-nbd -c /dev/nbd0 main.qcow2 -f qcow2
sudo growpart /dev/nbd0 1

sudo mkdir -p /mnt/main
sudo mount /dev/nbd0p1 /mnt/main

sudo rm -f /mnt/main/run/resolvconf/resolv.conf
sudo mkdir -p /mnt/main/run/resolvconf/
sudo cp /etc/resolv.conf /mnt/main/run/resolvconf/resolv.conf
sudo cp install.sh /mnt/main/install.sh
sudo chroot /mnt/main /install.sh
sudo rm /mnt/main/install.sh
sudo mkdir -p /mnt/main/var/lib/cloud/scripts/per-boot/
sudo cp actions-runner.sh /mnt/main/var/lib/cloud/scripts/per-boot/00-actions-runner.sh
sudo rm -f /mnt/main/run/resolvconf/resolv.conf


sudo umount /mnt/main
sleep 5
sudo qemu-nbd -d /dev/nbd0
sleep 5
sudo rmmod nbd
