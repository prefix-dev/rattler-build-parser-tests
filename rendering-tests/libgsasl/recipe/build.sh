#!/usr/bin/env bash

set -o xtrace -o nounset -o pipefail -o errexit

./configure --with-gssapi-impl=mit --enable-static=no --prefix=$PREFIX
make -j${CPU_COUNT}
if [[ "${CONDA_BUILD_CROSS_COMPILATION:-}" != "1" || "${CROSSCOMPILING_EMULATOR:-}" != "" ]]; then
make check -j${CPU_COUNT}
fi
make install
