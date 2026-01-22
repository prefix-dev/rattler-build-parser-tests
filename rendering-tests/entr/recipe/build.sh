#!/usr/bin/env bash

set -o xtrace -o nounset -o pipefail -o errexit

export MANPREFIX=${PREFIX}/share/man
./configure
make -j${CPU_COUNT}
if [[ ${CONDA_BUILD_CROSS_COMPILATION:-0} == 0 ]]; then
    TERM=xterm make -j${CPU_COUNT} test
fi
make -j${CPU_COUNT} install
