#!/usr/bin/env bash
# Enable bash strict mode
# http://redsymbol.net/articles/unofficial-bash-strict-mode/
set -euo pipefail
IFS=$'\n\t'

# ROOTIO is currently off, this could be added after ROOT adds a root-base formula

cmake -LAH \
    -DCMAKE_BUILD_TYPE=${CMAKE_PLATFORM_FLAGS[@]+"${CMAKE_PLATFORM_FLAGS[@]}"} \
    -DCMAKE_INSTALL_PREFIX=${PREFIX} \
    -DHEPMC3_ENABLE_ROOTIO=OFF \
    -DHEPMC3_ENABLE_PYTHON=ON \
    -DHEPMC3_BUILD_DOCS=ON \
    -DHEPMC3_BUILD_EXAMPLES=ON \
    -DHEPMC3_ENABLE_TEST=ON \
    -S source \
    -B build

cmake --build build --parallel "${CPU_COUNT}"
cmake --install build
ctest
