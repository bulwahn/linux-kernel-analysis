#!/bin/bash
#
# Copyright (C) Lukas Bulwahn, BMW Car IT GmbH
# SPDX-License-Identifier: GPL-2.0
#
# Builds the Docker images that we need to compile the kernel source
#

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

echo 'Building the Docker image "kernel-gcc"'
cd "$SCRIPT_DIR/../docker/kernel-gcc"
docker build -t kernel-gcc .

echo 'Building the Docker image "kernel-clang"'
cd "$SCRIPT_DIR/../docker/kernel-clang"
docker build -t kernel-clang .

echo 'Building the Docker image "kernel-coccinelle"'
cd "$SCRIPT_DIR/../docker/kernel-coccinelle"
docker build -t kernel-coccinelle .
