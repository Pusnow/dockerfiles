#!/bin/bash
set -ex
export DEBIAN_FRONTEND=noninteractive
apt-get update &&
    apt-get upgrade -y &&
    apt-get install -y --no-install-recommends \
        curl \
        ca-certificates \
        jq \
        git \
        python3 \
        python3-pip \
        build-essential \
        docker.io \
        cmake &&
    rm -rf /var/lib/apt/lists/* &&
    rm -rf /var/cache/apt/

mkdir -p /opt/actions-runner
cd /opt/actions-runner
GITHUB_RUNNER_VERSION=$(curl --silent 'https://api.github.com/repos/actions/runner/releases/latest' | jq -r '.tag_name[1:]')
curl -o actions-runner.tar.gz -L "https://github.com/actions/runner/releases/download/v${GITHUB_RUNNER_VERSION}/actions-runner-linux-x64-${GITHUB_RUNNER_VERSION}.tar.gz"

tar xzf ./actions-runner.tar.gz
rm ./actions-runner.tar.gz
./bin/installdependencies.sh
