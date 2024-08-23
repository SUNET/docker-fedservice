#!/bin/bash
set -e

GIT_DIR="src"

if [ -d "${GIT_DIR}" ]; then
    rm -rf "${GIT_DIR}"
fi
echo "Using ${UPSTREAM_VERSION}."
git clone --branch "${UPSTREAM_VERSION=master}" --depth 1 https://github.com/mikaelfrykholm/fedservice.git "${GIT_DIR}"
pushd "${GIT_DIR}"
pushd docker
./build.sh
