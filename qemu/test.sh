#!/bin/bash
set -x
set -e


docker build -t qemu-testing .

docker run -it --rm \
    --name qemu-testing \
    --device /dev/kvm \
    --volume /tmp/disks:/disks \
    -p 5901:5901 \
    -e QEMU_VNC="0.0.0.0:1" \
    -e QEMU_DISK_URL="https://cloud.debian.org/images/cloud/bullseye/latest/debian-11-nocloud-amd64.qcow2" \
    qemu-testing