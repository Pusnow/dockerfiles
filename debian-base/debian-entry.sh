#!/bin/sh
set -e
set -x

UID="${UID:-0}"
GID="${GID:-0}"

groupadd -g "${GID}" -f leaf

if [ "${UID}" = "$(id -u)" ]; then
    usermod -g "${GID}" "$(whoami)"
    exec $@
else
    useradd -u "${UID}" -g "${GID}" -l leaf
    exec sudo -u leaf $@
fi
