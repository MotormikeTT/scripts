#!/bin/bash -ex

set -o pipefail

if [ $# -ne 2 ]; then
    echo "Usage: $0 <APPLICATION_NAME> <RUNNER_TOKEN>"
    exit 1
fi

APPLICATION_NAME=$1
RUNNER_TOKEN=$2
LATEST=`curl -s -I https://github.com/actions/runner/releases/latest | sed -n '/^location:/{ s#.*tag/v##; s/\r//g; p; }' ` 

# Download and install runner script
cd ~
mkdir -p $APPLICATION_NAME-actions-runner
cd $APPLICATION_NAME-actions-runner
curl -L -s "https://github.com/actions/runner/releases/download/v${LATEST}/actions-runner-linux-x64-${LATEST}.tar.gz" -o actions-runner-linux-x64-${LATEST}.tar.gz
tar xzf ./actions-runner-linux-x64-${LATEST}.tar.gz

# Configure runner
RUNNER_ALLOW_RUNASROOT=1 ./config.sh --token $RUNNER_TOKEN --unattended

# Setup systemd scripts
./svc.sh install
./svc.sh start
./svc.sh status
