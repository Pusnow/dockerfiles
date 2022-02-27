#!/bin/sh

SSH_KEY=/root/.ssh/id_ed25519

if [ ! -f ${SSH_KEY} ]; then
    ssh-keygen -t ed25519 -f ${SSH_KEY} -N ""
fi

echo "Public key:"
cat ${SSH_KEY}.pub

exec /usr/bin/rsync $@
