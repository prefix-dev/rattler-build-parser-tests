#!/usr/bin/env bash

set -x
set -e

# Create a build directory and navigate into it
mkdir -p build
cd build

# Configure the build using CMake
cmake .. -DCMAKE_INSTALL_PREFIX="${PREFIX}" -DCMAKE_BUILD_TYPE=Release

# Build the project
cmake --build . -- -j${CPU_COUNT}

# Install the binaries
cmake --install .
