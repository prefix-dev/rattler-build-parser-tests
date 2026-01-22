#!/usr/bin/env bash

set -o xtrace -o nounset -o pipefail -o errexit

./configure --disable-debug \
    --disable-dependency-tracking \
    --enable-shared \
    --prefix=${PREFIX} \
    --libdir=${PREFIX}/lib \
    AR=${AR} \
    CC=${CC}

if [[ "${CONDA_BUILD_CROSS_COMPILATION:-}" != "1" || "${CROSSCOMPILING_EMULATOR:-}" != "" ]]; then
    make -j${CPU_COUNT} check
fi
make -j${CPU_COUNT} install
