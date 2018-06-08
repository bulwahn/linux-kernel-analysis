FROM debian:latest

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
      openjdk-8-jdk-headless \
      pkg-config \
      python2.7 \
      wget \
      zlib1g-dev && \
    rm -rf /var/lib/apt/lists/*

# Download the latest Infer release
RUN INFER_VERSION=v0.14.0; \
    cd /opt && \
    curl -sL \
      https://github.com/facebook/infer/releases/download/${INFER_VERSION}/infer-linux64-${INFER_VERSION}.tar.xz | \
    tar xJ && \
    rm -f /infer && \
    ln -s ${PWD}/infer-linux64-$INFER_VERSION /infer

# Compile Infer
RUN OCAML_VERSION=4.06.1+flambda; \
    cd /infer && ./build-infer.sh clang --opam-switch $OCAML_VERSION && rm -rf /root/.opam

# Install Infer
ENV INFER_HOME /infer/infer
ENV PATH ${INFER_HOME}/bin:${PATH}
