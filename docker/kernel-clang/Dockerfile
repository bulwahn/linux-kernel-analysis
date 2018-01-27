# Copyright (C) Lukas Bulwahn, BMW Car IT GmbH
# SPDX-License-Identifier: GPL-2.0
FROM debian:buster

LABEL maintainer="Lukas Bulwahn <lukas.bulwahn@gmail.com>"

# Install tools needed for kernel build and clang compiler
RUN apt-get update && apt-get install --no-install-recommends -y \
	bc \
	bison \
	bsdmainutils \
	clang-5.0 \
	flex \
	libelf-dev \
	libssl-dev \
	make \
	&& rm -rf /var/lib/apt/lists/*
