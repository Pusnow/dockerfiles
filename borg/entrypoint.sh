#!/bin/sh
echo "Installing SSH Keys..."
mkdir -p "$HOME/.ssh"
cp -r /keys/* "$HOME/.ssh"

if [ -z "${REPEAT}" ]; then
    /usr/bin/borg $@
else
    while :; do
        /usr/bin/borg $@
        sleep "${REPEAT}"
    done
fi
