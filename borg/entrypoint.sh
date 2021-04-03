#!/bin/sh
echo "Installing SSH Keys..."
mkdir -p "$HOME/.ssh"
cp -r /keys/* "$HOME/.ssh"


/usr/bin/borg $@