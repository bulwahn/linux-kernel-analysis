# Copyright (C) Lukas Bulwahn, BMW Car IT GmbH
# SPDX-License-Identifier: GPL-2.0
FROM debian:buster

LABEL maintainer="Lukas Bulwahn <lukas.bulwahn@gmail.com>"

# Install tools needed for kernel build and clang compiler
RUN apt-get update && apt-get install --no-install-recommends -y \
	bc \
	bison \
	bsdmainutils \
	ca-certificates \
	gnupg \
	gnupg-utils \
	flex \
	libelf-dev \
	libssl-dev \
	make \
	wget

RUN echo "deb http://apt.llvm.org/unstable/ llvm-toolchain main" >> /etc/apt/sources.list \
	&& wget -O - https://apt.llvm.org/llvm-snapshot.gpg.key | apt-key add - \
	&& apt-get update \
	&& apt-get install --no-install-recommends -y clang-7 \
	&& rm -rf /var/lib/apt/lists/*
