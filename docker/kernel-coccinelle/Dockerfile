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
	make \
	git \
	build-essential \
	autoconf \
	automake \
	pkg-config \
	ocaml \
	ocaml-findlib \
	python3 \
	libpython3-dev \
	ca-certificates \
	&& rm -rf /var/lib/apt/lists/*
RUN update-alternatives --install /usr/bin/python python /usr/bin/python3 10
RUN git clone https://github.com/coccinelle/coccinelle.git /coccinelle
WORKDIR /coccinelle
RUN ./autogen && ./configure && make && make install
WORKDIR /
