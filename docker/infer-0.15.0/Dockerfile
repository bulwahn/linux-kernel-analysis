FROM debian:stretch-slim

LABEL maintainer "Ozan Alpay <ozanalpay@yandex.com.tr>"

# mkdir the man/man1 directory due to Debian bug #863199
RUN apt-get update && \
    mkdir -p /usr/share/man/man1 && \
    apt-get install --yes --no-install-recommends \
      autoconf \
      automake \
      bc \
      bison \
      bsdmainutils \
      ca-certificates \
      cmake \
      clang \
      curl \
      flex \
      git \
      gnupg \
      libc6-dev \
      libelf-dev \
      libsqlite3-dev \
      libssl-dev \
      make \
      opam \
      pkg-config \
      python2.7 \
      wget \
      zlib1g-dev && \
rm -rf /var/lib/apt/lists/*

# Download the latest Infer release
RUN INFER_VERSION=v0.15.0; \
    cd /opt && \
    curl -sL \
      https://github.com/facebook/infer/releases/download/${INFER_VERSION}/infer-linux64-${INFER_VERSION}.tar.xz | \
    tar xJ && \
    rm -f /infer && \
    ln -s ${PWD}/infer-linux64-$INFER_VERSION /infer


# Install Infer
ENV INFER_HOME /infer/infer
ENV PATH ${INFER_HOME}/bin:${PATH}

