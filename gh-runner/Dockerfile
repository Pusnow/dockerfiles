FROM myoung34/github-runner:debian-bullseye

RUN apt-get update \
    && apt-get install -y \
    podman \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /var/cache/apt/