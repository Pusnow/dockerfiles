#!/bin/bash
set -ex

if [ -f /sys/firmware/qemu_fw_cfg/by_name/opt/github/raw ]; then
    gh_id="$(cat /sys/firmware/qemu_fw_cfg/by_name/opt/github/raw)"
    mkdir -p /root/.ssh
    wget --no-cache --no-cookies -o /dev/null -O /root/.ssh/authorized_keys https://github.com/${gh_id}.keys
fi
