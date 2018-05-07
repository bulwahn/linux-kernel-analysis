#!/bin/bash
#
# Copyright (C) Lukas Bulwahn, BMW Car IT GmbH
# SPDX-License-Identifier: GPL-2.0
#
# Builds the Docker images that we need to compile the kernel source
#

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

for DOCKER_IMAGE in $(find $SCRIPT_DIR/../docker -mindepth 1 -maxdepth 1 -type d -printf "%f\n")
do
	echo Building the Docker image "$DOCKER_IMAGE"
	cd "$SCRIPT_DIR/../docker/$DOCKER_IMAGE"
	docker build -t $DOCKER_IMAGE .
done
