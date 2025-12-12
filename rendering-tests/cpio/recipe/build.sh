#!/usr/bin/env bash

set -o xtrace -o nounset -o pipefail -o errexit

./configure --disable-debug \
    --disable-dependency-tracking \
    --disable-silent-rules \
    --prefix=${PREFIX} \
    --libdir=${PREFIX}/lib

if [[ ${CONDA_BUILD_CROSS_COMPILATION:-0} == 0 ]]; then
    if [[ ${target_platform} != "linux-ppc64le" ]] && [[ ${target_platform} != "linux-aarch64" ]]; then
        make -j${CPU_COUNT} check
    fi
fi
make -j${CPU_COUNT} install
