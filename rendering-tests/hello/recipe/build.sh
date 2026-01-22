#!/usr/bin/env bash

set -o xtrace -o nounset -o pipefail -o errexit

if [[ $target_platform =~ .*osx.* ]]; then
    LDFLAGS="${LDFLAGS} -liconv"
fi

./configure --disable-silent-rules \
    --disable-dependency-tracking \
    --prefix=${PREFIX}
if [[ ${CONDA_BUILD_CROSS_COMPILATION:-0} == 0 ]]; then
    make -j${CPU_COUNT} check
fi
make -j${CPU_COUNT} install
