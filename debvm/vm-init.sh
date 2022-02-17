#!/bin/bash
set -ex

if [ -b "/dev/vdb" ]; then
  if [ -z "$(blkid -n ext4 /dev/vdb)" ]; then
    mkfs.ext4 -q /dev/vdb
  fi
  rm -rf /root
  mkdir -p /root
  mount -t ext4 /dev/vdb /root
fi

rm -rf /sshd
mkdir -p /sshd

if [ -b "/dev/vdc" ]; then
  if [ -z "$(blkid -n ext4 /dev/vdc)" ]; then
    mkfs.ext4 -q /dev/vdc
  fi
  mount -t ext4 /dev/vdc /sshd
fi

if [ ! -f "/sshd/host_key" ]; then
    ssh-keygen -t ed25519 -f /sshd/host_key -N ""
fi

if [ -f /sys/firmware/qemu_fw_cfg/by_name/opt/hostname/raw ]; then
    hostname="$(cat /sys/firmware/qemu_fw_cfg/by_name/opt/hostname/raw)"
    hostname ${hostname}
fi
