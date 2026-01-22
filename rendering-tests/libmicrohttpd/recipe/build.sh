#!/bin/bash
# Get an updated config.sub and config.guess
cp $BUILD_PREFIX/share/gnuconfig/config.* ./build-aux

set -eo pipefail

./configure --disable-dependency-tracking --disable-silent-rules --prefix=${PREFIX} --enable-shared --disable-static
make -j${CPU_COUNT}
make install
