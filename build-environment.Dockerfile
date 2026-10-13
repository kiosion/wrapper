# Toolchain for building lite and the QEMU guest assets, matching CI's
# ubuntu-22.04 runner. The NDK is mounted at /src/android-ndk-r23b at run time.
FROM --platform=linux/amd64 ubuntu:22.04

ARG CMAKE_VERSION=3.31.12
ARG CMAKE_SHA256=0dc2e9a6860f06bf10bd8fadc03e35d9eeb4df46e33763a7e480e987758f385c

RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        build-essential ca-certificates cpio curl e2fsprogs git gzip unzip \
        linux-image-generic

# Ubuntu 22.04 ships CMake 3.22; CMakeLists.txt requires 3.25. CMake 4 rejects
# cJSON's cmake_minimum_required(VERSION 3.0).
RUN curl -fsSL -o /tmp/cmake.tar.gz \
        "https://github.com/Kitware/CMake/releases/download/v${CMAKE_VERSION}/cmake-${CMAKE_VERSION}-linux-x86_64.tar.gz" \
    && echo "${CMAKE_SHA256}  /tmp/cmake.tar.gz" | sha256sum -c - \
    && tar -xzf /tmp/cmake.tar.gz -C /opt \
    && ln -s "/opt/cmake-${CMAKE_VERSION}-linux-x86_64/bin/cmake" /usr/local/bin/cmake \
    && rm /tmp/cmake.tar.gz

WORKDIR /src
