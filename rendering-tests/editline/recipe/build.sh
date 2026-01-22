#!/usr/bin/env bash
set -ex

if [[ "$target_platform" == "osx-arm64" ]]; then
  autoreconf -vfi
fi
./configure --prefix="${PREFIX}"
make all -j ${CPU_COUNT}
make check
make install
