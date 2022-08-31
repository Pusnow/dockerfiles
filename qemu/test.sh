#!/bin/bash
set -x
set -e

DEBIAN_NOCLOUD_URL="https://cloud.debian.org/images/cloud/bullseye/latest/debian-11-nocloud-amd64.qcow2"
DEBIAN_GENERICCLOUD_URL="https://cloud.debian.org/images/cloud/bullseye/latest/debian-11-genericcloud-amd64.qcow2"
FCOS_URL="https://builds.coreos.fedoraproject.org/prod/streams/stable/builds/36.20220723.3.1/x86_64/fedora-coreos-36.20220723.3.1-qemu.x86_64.qcow2.xz"

docker build -t qemu-testing .

docker run -it --rm \
    --name qemu-testing \
    --device /dev/kvm \
    --volume /tmp/disks:/disks \
    --volume ${PWD}/example.yaml:/root/example.yaml:ro \
    -p 5901:5901 \
    -p 2222:22 \
    -e QEMU_VNC="0.0.0.0:1" \
    -e QEMU_DISK_URL="${DEBIAN_GENERICCLOUD_URL}" \
    -e QEMU_CONSOLE="Y" \
    -e QEMU_CLOUD_INIT="/root/example.yaml" \
    -e QEMU_TCP_PORTS="22" \
    qemu-testing
