#!/usr/bin/env bash

set -o xtrace -o nounset -o pipefail -o errexit

export CFLAGS="${CFLAGS} -Wno-int-conversion -Wno-implicit-function-declaration"

make -j${CPU_COUNT}
if [[ ${CONDA_BUILD_CROSS_COMPILATION:-0} == 0 ]]; then
    make -j${CPU_COUNT} test
fi
make -j${CPU_COUNT} PREFIX=${PREFIX} install
