#!/usr/bin/env bash
set -eux -o pipefail

if [[ "${host_platform}" == "linux-aarch64" || "${host_platform}" == "linux-ppc64le" ]]; then
  # from https://conda-forge.org/docs/how-to/advanced/cross-compilation/
  cp "${BUILD_PREFIX}/share/gnuconfig"/config.* .
  # avoid errors like...
  #   klparse.cpp:163:17: error: narrowing conversion of '-1' from 'int' to 'char' [-Wnarrowing]
  export CXXFLAGS="${CXXFLAGS} -Wno-narrowing"
fi

./configure --prefix "${PREFIX}"

make
make install

# Skip ``make check`` when cross-compiling
if [[ "${CONDA_BUILD_CROSS_COMPILATION:-}" != "1" || "${CROSSCOMPILING_EMULATOR:-}" != "" ]]; then
  make check
  make installcheck
fi
