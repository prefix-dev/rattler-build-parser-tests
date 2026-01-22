#!/usr/bin/env bash

set -o xtrace -o nounset -o pipefail -o errexit

export CFLAGS="${CFLAGS} -fcommon"
./autogen.sh
# turn clang-format test off: otherwise Mac build gives
#   fatal: not a git repository (or any of the parent directories): .git
# and then hangs forever for some reason
CLANG_FORMAT=no ./configure --prefix="${PREFIX}"
make -j${CPU_COUNT}
if [[ "${CONDA_BUILD_CROSS_COMPILATION:-}" != "1" || "${CROSSCOMPILING_EMULATOR:-}" != "" ]]; then
make test
fi
make -j${CPU_COUNT} install
