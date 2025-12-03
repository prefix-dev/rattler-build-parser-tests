#!/usr/bin/env bash

set -o xtrace -o nounset -o pipefail -o errexit

if [[ $target_platform =~ .*osx.* ]]; then
    export LDFLAGS="-liconv"
fi
./autogen.sh
./configure --disable-silent \
    --disable-debug \
    --disable-dependency-tracking \
    --prefix=${PREFIX}
make -j${CPU_COUNT} install LIBS="-Wl,-rpath,${PREFIX}/lib -L${PREFIX}/lib -liconv"
if [[ ${CONDA_BUILD_CROSS_COMPILATION:-0} == 0 ]]; then
    make -j${CPU_COUNT} tests LIBS="-Wl,-rpath,${PREFIX}/lib -L${PREFIX}/lib -liconv"
fi
