#!/bin/bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$SCRIPT_DIR/../docker/infer-0.13.1"
DOCKER_NAME="kernel-analysis-infer-0.13.1"
docker build -t $DOCKER_NAME .
cd "../infer-0.14.0"
DOCKER_NAME="kernel-analysis-infer-0.14.0"
docker build -t $DOCKER_NAME .
cd "../infer-0.15.0"
DOCKER_NAME="kernel-analysis-infer-0.15.0"
docker build -t $DOCKER_NAME .
