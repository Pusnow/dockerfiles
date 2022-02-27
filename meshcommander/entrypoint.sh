#!/bin/sh

echo "Installing SSH Keys..."
mkdir -p "$HOME/.ssh"
cp -r /keys/* "$HOME/.ssh"


if [ "$#" -gt 0 ]; then
    server=$2
    ssh=$1
if [ "$#" -lt 2 ]; then
    server=$ssh
fi
    echo "Connecting $server via $ssh (SSH) ..."
    /usr/bin/ssh -fN \
        -L127.0.0.1:5900:$server:5900   \
        -L127.0.0.1:16992:$server:16992 \
        -L127.0.0.1:16993:$server:16993 \
        -L127.0.0.1:16994:$server:16994 \
        -L127.0.0.1:16995:$server:16995 \
        -L127.0.0.1:623:$server:623 \
        -L127.0.0.1:664:$server:664 \
        $ssh
fi


echo "Starting Mesh Commander ..."
exec node meshcommander --any