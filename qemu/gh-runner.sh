#!/bin/bash
set -x
set -e

DEBIAN_GENERICCLOUD_URL="https://cloud.debian.org/images/cloud/bullseye/latest/debian-11-genericcloud-amd64.qcow2"

docker build -t gh-runner-testing .

docker run -it --rm \
    --name gh-runner-testing \
    --device /dev/kvm \
    --volume /tmp/disks:/disks \
    --volume ${PWD}/gh-runner.yaml:/root/gh-runner.yaml:ro \
    --volume ${PWD}/gh-runner-init.sh:/init.d/00-gh-runner-init.sh:ro \
    -e QEMU_VNC="0.0.0.0:1" \
    -e QEMU_DISK_URL="${DEBIAN_GENERICCLOUD_URL}" \
    -e QEMU_CONSOLE="Y" \
    -e QEMU_CLOUD_INIT="/root/gh-runner.yaml" \
    -e QEMU_TCP_PORTS="22" \
    gh-runner-testing
