#!/bin/sh
set -e
set -x

UID="${UID:-0}"
GID="${GID:-0}"

if [ -d "/init.d/" ]; then
    for SCRIPT in /init.d/*.sh; do
        . "${SCRIPT}"
    done
fi

groupadd -g "${GID}" -f leaf

if [ "${UID}" = "$(id -u)" ]; then
    usermod -g "${GID}" "$(whoami)"

    if [ -f "/entrypoint.sh" ]; then
        exec /entrypoint.sh $@
    else
        exec $@
    fi

else
    useradd -u "${UID}" -g "${GID}" -l leaf
    if [ -f "/entrypoint.sh" ]; then
        exec sudo -u leaf /entrypoint.sh $@
    else
        exec sudo -u leaf $@
    fi
fi
