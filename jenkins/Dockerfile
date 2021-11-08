FROM jenkins/jenkins:lts

USER root

RUN apt-get update && apt-get install -y \
    apt-transport-https \
    ca-certificates curl gnupg2 \
    software-properties-common \
    docker.io \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

USER jenkins