#!/usr/bin/env bash
mkdir -p $HOME/.ssh
wget --no-cache --no-cookies -o /dev/null -O  $HOME/.ssh/authorized_keys https://github.com/pusnow.keys 2>&1
/usr/sbin/sshd -D -e