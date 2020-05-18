#!/bin/bash

cd "$(dirname "$0")"
git pull

declare -a IMAGES=(
    "debian:buster-slim"
    "python:slim-buster"
)

for IMAGE in "${IMAGES[@]}"
do
    make BASE_IMAGE=${IMAGE}
done

