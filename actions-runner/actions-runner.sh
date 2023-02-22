#!/bin/bash
set -x

echo "============== Starting GitHub Self-Hosted Runner ==================="
cd /opt/actions-runner

TOKEN="$(cat /sys/firmware/qemu_fw_cfg/by_name/opt/runner/token/raw | jq -r '.token' || true)"
ORG="$(cat /sys/firmware/qemu_fw_cfg/by_name/opt/runner/org/raw || true)"
NAME="$(cat /sys/firmware/qemu_fw_cfg/by_name/opt/runner/name/raw || true)"
LABEL="$(cat /sys/firmware/qemu_fw_cfg/by_name/opt/runner/label/raw || true)"
RUNNER_GROUP="$(cat /sys/firmware/qemu_fw_cfg/by_name/opt/runner/group/raw || true)"

export RUNNER_ALLOW_RUNASROOT="1"
./config.sh \
    --url https://github.com/${ORG} \
    --name "${NAME}" \
    --token "${TOKEN}" \
    --runnergroup "${RUNNER_GROUP}" \
    --labels "${LABEL}" \
    --disableupdate --ephemeral --unattended --replace
./run.sh
echo "============== Exiting GitHub Self-Hosted Runner ==================="
shutdown -h now
