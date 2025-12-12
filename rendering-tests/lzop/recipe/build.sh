#!/usr/bin/env bash

set -o xtrace -o nounset -o pipefail -o errexit

# Get an updated config.sub and config.guess
cp $BUILD_PREFIX/share/gnuconfig/config.* ./autoconf

./configure --prefix=${PREFIX}
make -j ${CPU_COUNT}
make install
