#!/bin/sh
set -e
set -x

UID="${UID:-2000}"
GID="${GID:-2000}"

groupadd -g "${GID}" leaf && useradd -u "${UID}" -g "${GID}" -l leaf

exec sudo -u leaf $@