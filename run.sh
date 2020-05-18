#!/bin/bash

declare -a IMAGES=(
    "debian:buster-slim"
    "python:slim-buster"
)

for IMAGE in "${IMAGES[@]}"
do
    make BASE_IMAGE=${IMAGE} push
done