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

if [ ! $(getent group "${GID}") ]; then
    groupadd -g "${GID}" -f leaf
fi

if [ "${UID}" = "$(id -u)" ]; then
    usermod -g "${GID}" "$(whoami)"

    if [ -f "/entrypoint.sh" ]; then
        exec /entrypoint.sh $@
    else
        exec $@
    fi

else
    if [ ! $(getent passwd "${UID}") ]; then
        useradd -u "${UID}" -g "${GID}" -l leaf
    fi
    if [ -f "/entrypoint.sh" ]; then
        exec sudo -E -u "#${UID}" /entrypoint.sh $@
    else
        exec sudo -E -u "#${UID}" $@
    fi
fi
