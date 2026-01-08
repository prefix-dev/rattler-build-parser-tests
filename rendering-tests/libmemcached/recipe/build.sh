#!/bin/bash
set -e
set -x

# Get an updated config.sub and config.guess
cp "${BUILD_PREFIX}"/share/gnuconfig/config.* ./build-aux

./configure --prefix="${PREFIX}"

make "${VERBOSE_AT}"
## tests hang on `testapp` on osx and linux
# make check
make install
