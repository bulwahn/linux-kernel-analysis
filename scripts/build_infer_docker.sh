#!/bin/bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$SCRIPT_DIR/../docker/infer"
DOCKER_NAME="kernel-analysis"
docker build -t $DOCKER_NAME .
