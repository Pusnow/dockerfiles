#!/bin/sh

if [ ! -f "/ssh/host_key" ]; then
    ssh-keygen -t ed25519 -f /ssh/host_key -N ""
fi

if [ $# -eq 0 ]; then
    mkdir -p /run/sshd
    eval $(ssh-agent)
    exec /usr/sbin/sshd -D -e
else
    exec $@
fi
