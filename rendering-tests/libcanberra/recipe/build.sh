#!/usr/bin/env bash

set -o xtrace -o nounset -o pipefail -o errexit

export GTKDOCIZE=echo

autoreconf --force --verbose --install

./configure \
  --prefix="${PREFIX}" \
  --with-gnu-ld

if [[ ${target_platform} =~ .*osx.* ]]; then
    sed -i 's/-Wl,--as-needed -Wl,--gc-sections//' config.status
fi

make -j "${CPU_COUNT}"
make check
make install
