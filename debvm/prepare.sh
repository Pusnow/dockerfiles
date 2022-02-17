#!/bin/bash
set -ex
sudo apt-get update && sudo apt-get install -y qemu-utils
sudo ./build.sh