#!/bin/bash
set -x
set -e

DEBIAN_NOCLOUD_URL="https://cloud.debian.org/images/cloud/bookworm/latest/debian-12-nocloud-amd64.qcow2"
DEBIAN_GENERICCLOUD_URL="https://cloud.debian.org/images/cloud/bookworm/latest/debian-12-genericcloud-amd64.qcow2"
FCOS_URL="https://builds.coreos.fedoraproject.org/prod/streams/stable/builds/36.20220723.3.1/x86_64/fedora-coreos-36.20220723.3.1-qemu.x86_64.qcow2.xz"

sudo podman build -t qemu-testing .

sudo podman run -it --rm \
    --name qemu-testing \
    --device /dev/kvm \
    --cap-add=NET_ADMIN --device /dev/net/tun:/dev/net/tun \
    --volume /var/tmp/disks:/disks \
    --volume ${PWD}/cloudinit:/root/cloudinit:ro \
    -p 5901:5901 \
    -p 2222:22 \
    -e QEMU_DISK2=/disks/swap.qcow2 \
    -e QEMU_VNC="0.0.0.0:1" \
    -e QEMU_DISK_URL="${DEBIAN_GENERICCLOUD_URL}" \
    -e QEMU_CONSOLE="Y" \
    -e QEMU_CLOUD_INIT="/root/cloudinit" \
    -e QEMU_TCP_PORTS="22" \
    -e QEMU_TAP_AUTO="1" \
    qemu-testing
