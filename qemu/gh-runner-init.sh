#!/bin/bash
set -e

RUNNER_ARGS=""

if [ -n "${RUNNER_PAT}" ]; then
    curl -XPOST -fsSL \
        -o /tmp/runner-token \
        -H "Content-Length: 0" \
        -H "Authorization: token ${RUNNER_PAT}" \
        -H "Accept: application/vnd.github.v3+json" \
        "https://api.github.com/orgs/${RUNNER_ORG}/actions/runners/registration-token"

    RUNNER_ARGS="${RUNNER_ARGS} -fw_cfg name=opt/runner/token,file=/tmp/runner-token"
else
    echo "Fail to retrieve runner token"
    exit 1
fi

if [ -n "${RUNNER_ORG}" ]; then
    RUNNER_ARGS="${RUNNER_ARGS} -fw_cfg name=opt/runner/org,string=${RUNNER_ORG}"
else
    echo "No RUNNER_ORG set"
    exit 1
fi

if [ -n "${RUNNER_NAME}" ]; then
    RUNNER_ARGS="${RUNNER_ARGS} -fw_cfg name=opt/runner/name,string=${RUNNER_NAME}"
else
    echo "vm-$(cat /etc/hostname)" >/tmp/vm-name
    RUNNER_ARGS="${RUNNER_ARGS} -fw_cfg name=opt/runner/name,file=/tmp/vm-name"
fi

if [ -n "${RUNNER_LABEL}" ]; then
    RUNNER_ARGS="${RUNNER_ARGS} -fw_cfg name=opt/runner/label,string=${RUNNER_LABEL}"
else
    RUNNER_ARGS="${RUNNER_ARGS} -fw_cfg name=opt/runner/label,string=runner"
fi

if [ -n "${RUNNER_RUNNER_GROUP}" ]; then
    RUNNER_ARGS="${RUNNER_ARGS} -fw_cfg name=opt/runner/group,string=${RUNNER_RUNNER_GROUP}"
else
    RUNNER_ARGS="${RUNNER_ARGS} -fw_cfg name=opt/runner/group,string=Default"
fi

export QEMU_EXTRA_ARGS="${RUNNER_ARGS}"
