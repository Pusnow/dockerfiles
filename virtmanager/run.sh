#!/bin/bash

echo "Installing SSH Keys..."
mkdir -p "$HOME/.ssh"
cp -r /keys/* "$HOME/.ssh"

echo "Starting Virt Manager..."
/usr/bin/virt-manager --no-fork