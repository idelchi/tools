#!/usr/bin/env bash
set -euo pipefail

apt-get update && apt-get install --no-install-recommends -y \
    build-essential \
    clang \
    curl \
    wget \
    git \
    nodejs \
    npm \
    ca-certificates \
    graphviz \
    gettext-base \
    moreutils \
    iputils-ping \
    procps \
    bsdextrautils \
    vim-common \
    coreutils \
    tree \
    zsh \
    nano \
    net-tools \
    telnet \
    lsof \
    iproute2 \
    rsync \
    xxd \
    dnsutils \
    git-lfs \
    netcat-openbsd \
    unzip \
    && rm -rf /var/lib/apt/lists/*

git lfs install --system
