# syntax=docker/dockerfile:1

# Use Ubuntu base image
FROM ubuntu:24.04

LABEL maintainer="devmichalek@gmail.com"

# Install build dependencies
RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends -y \
        curl \
        build-essential \
        pkg-config \
        make \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN apt-get update && apt-get install -y ca-certificates
RUN apt update && apt-get install sudo -y

ENV RUSTUP_HOME=/usr/local/rustup
ENV CARGO_HOME=/usr/local/cargo

# Install rustup a command line tool for managing Rust version and associated tools
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- \
    --no-modify-path \
    --default-toolchain stable \
    --profile minimal \
    -y

# Ensure the shared cargo binaries are in PATH for all users
ENV PATH="${CARGO_HOME}/bin:${PATH}"

# Verify rustup installation and update
RUN rustup --version
RUN rustup update
RUN rustup component add rustfmt

# Setup group and user
ARG USER_ID=1001
ARG GROUP_ID=1001
ARG USER_NAME=juser
ARG GROUP_NAME=jgroup
RUN groupadd -o -r $GROUP_NAME --gid=$GROUP_ID
RUN useradd -o -r -g $GROUP_NAME --uid=$USER_ID --shell=/bin/bash --create-home $USER_NAME

# Copy application sources
COPY --chown=$USER_NAME:$GROUP_ID app/ /home/$USER_NAME/app/

WORKDIR /home/$USER_NAME/app

# Switch to user account
USER $USER_NAME

# Verify installation
RUN cargo --version && rustc --version
