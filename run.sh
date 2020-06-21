#!/bin/bash

cd "$(dirname "$0")"
git pull

declare -a IMAGES=(
    "debian:buster-slim"
    "python:slim-buster"
    "php:7-buster"
    "php:7-fpm-buster"
)

for IMAGE in "${IMAGES[@]}"
do
    make BASE_IMAGE=${IMAGE} push
done

