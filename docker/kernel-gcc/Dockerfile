# Copyright (C) Lukas Bulwahn, BMW Car IT GmbH
# SPDX-License-Identifier: GPL-2.0
FROM debian:buster

LABEL maintainer="Lukas Bulwahn <lukas.bulwahn@gmail.com>"

# Install tools needed for kernel build and gcc compiler
RUN apt-get update && apt-get install --no-install-recommends -y \
	bc \
	bison \
	bsdmainutils \
	gcc \
	flex \
	libelf-dev \
	libssl-dev \
	make \
	openssl \
	git \
	build-essential \
	autoconf \
	automake \
	libxml2-dev \
	libgtk-3-dev \
	llvm-dev \
	ca-certificates \
	&& rm -rf /var/lib/apt/lists/*
RUN update-alternatives --install /usr/bin/python python /usr/bin/python3 10
RUN git clone https://git.kernel.org/pub/scm/devel/sparse/sparse.git /sparse
WORKDIR /sparse
RUN make && make install PREFIX=/usr
WORKDIR /
