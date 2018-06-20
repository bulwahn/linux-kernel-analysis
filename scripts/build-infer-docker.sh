#!/bin/bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
USER_ID=$(id -u)
GROUP_ID=$(id -g)
USER_NAME=$(whoami)
GROUP_NAME=$(id -g -n $USER_NAME)
cd "$SCRIPT_DIR/../docker/infer-0.13.1"
DOCKER_NAME="kernel-analysis-infer-0.13.1"
docker build -t $DOCKER_NAME .  --build-arg user_id=$USER_ID --build-arg group_id=$GROUP_ID --build-arg user_name=$USER_NAME --build-arg group_name=$GROUP_NAME
cd "../infer-0.14.0"
DOCKER_NAME="kernel-analysis-infer-0.14.0"
docker build -t $DOCKER_NAME .  --build-arg user_id=$USER_ID --build-arg group_id=$GROUP_ID --build-arg user_name=$USER_NAME --build-arg group_name=$GROUP_NAME
cd "../infer-0.15.0"
DOCKER_NAME="kernel-analysis-infer-0.15.0"
docker build -t $DOCKER_NAME .  --build-arg user_id=$USER_ID --build-arg group_id=$GROUP_ID --build-arg user_name=$USER_NAME --build-arg group_name=$GROUP_NAME
