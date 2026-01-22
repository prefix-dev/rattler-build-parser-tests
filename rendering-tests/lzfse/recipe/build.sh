#!/usr/bin/env bash

set -o xtrace -o nounset -o pipefail -o errexit

cmake -S . -B build \
    -DCMAKE_POLICY_VERSION_MINIMUM=3.5 \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_VERBOSE_MAKEFILE=ON \
    -Wno-dev \
    -DBUILD_SHARED_LIBS=ON \
    -DLZFSE_BUNDLE_MODE=OFF \
    ${CMAKE_ARGS}

cmake --build build -j${CPU_COUNT}
ctest -V
cmake --install build
