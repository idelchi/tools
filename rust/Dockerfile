FROM rust:latest

RUN apt-get update && apt-get install -y --no-install-recommends \
    sccache \
    gcc-mingw-w64-x86-64 \
    && rm -rf /var/lib/apt/lists/*

ENV CARGO_HOME=/usr/local/cargo
ENV CARGO_TARGET_DIR=${CARGO_HOME}/target
ENV RUSTC_WRAPPER=/usr/bin/sccache
ENV SCCACHE_DIR=/opt/sccache

# Ensure toolchain/target present
RUN rustup target add x86_64-pc-windows-gnu

ARG BIN_DIR=/opt/rust
# Cache crates, git deps, *and compiled artifacts*
RUN --mount=type=cache,target=${CARGO_HOME}/registry \
    --mount=type=cache,target=${CARGO_HOME}/git \
    --mount=type=cache,target=${CARGO_TARGET_DIR} \
    --mount=type=cache,target=${SCCACHE_DIR} \
    cargo install --locked \
    --root ${BIN_DIR} \
    --target x86_64-pc-windows-gnu \
    \
    lumen \
    atuin


ENV PATH=${PATH}:${BIN_DIR}/bin
