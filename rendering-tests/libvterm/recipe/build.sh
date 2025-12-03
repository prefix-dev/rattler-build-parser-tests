#!/usr/bin/env bash

set -o xtrace -o nounset -o pipefail -o errexit

make install LIBTOOL=${PREFIX}/bin/libtool PREFIX=${PREFIX}
if [[ "${CONDA_BUILD_CROSS_COMPILATION:-}" != "1" || "${CROSSCOMPILING_EMULATOR-}" != "" ]]; then
make test LIBTOOL=${PREFIX}/bin/libtool PREFIX=${PREFIX}
fi

rm -f ${PREFIX}/lib/libvterm.a
