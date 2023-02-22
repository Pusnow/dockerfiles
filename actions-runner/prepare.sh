#!/bin/bash
set -ex


docker pull ghcr.io/pusnow/qemu:latest
docker pull busybox:latest

docker run -it --rm -v ${PWD}/qcow2:/disks busybox:latest rm -f /disks/main.qcow2 

docker run -it --rm \
    --device /dev/kvm \
    -v ${PWD}/gh-runner.yaml:/gh-runner.yaml:ro \
    -v ${PWD}/qcow2:/disks \
    -e QEMU_DISK_URL=https://cloud.debian.org/images/cloud/bullseye/latest/debian-11-genericcloud-amd64.qcow2 \
    -e QEMU_DISK_INITIALIZE=64G \
    -e QEMU_SMP=2 \
    -e QEMU_CONSOLE=Y \
    -e QEMU_MEMORY=16G \
    -e QEMU_CLOUD_INIT=/gh-runner.yaml \
    ghcr.io/pusnow/qemu:latest
