#!/bin/sh

if [ -n "$SSH_KEY" ]; then
    mkdir -p /ssh
    wget --no-cache --no-cookies -o /dev/null -O /ssh/authorized_keys "$SSH_KEY" 2>&1

fi

if [ ! -f "/ssh/host_key" ]; then
    ssh-keygen -t ed25519 -f /ssh/host_key -N ""
fi

if [ $# -eq 0 ]; then
    mkdir -p /run/sshd
    eval $(ssh-agent)
    /usr/sbin/sshd -D -e
else
    $@
fi
