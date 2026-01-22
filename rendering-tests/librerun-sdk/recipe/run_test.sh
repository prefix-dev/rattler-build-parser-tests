#!/bin/bash -e

# See https://conda-forge.org/docs/maintainer/knowledge_base.html#newer-c-features-with-old-sdk
# We pass this also on non-macos as it is harmless
CXXFLAGS="${CXXFLAGS} -D_LIBCPP_DISABLE_AVAILABILITY"

# Test linking against the rerun library
cd examples/cpp/minimal

# Compile example that links assimp
cmake -GNinja -DCMAKE_BUILD_TYPE=Release -DRERUN_FIND_PACKAGE:BOOL=ON .

cmake --build . --config Release
