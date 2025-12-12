#!/bin/bash

# Get an updated config.sub and config.guess
cp $BUILD_PREFIX/share/gnuconfig/config.* . || true

./configure --prefix=${PREFIX}  \
            --host=${HOST}      \
            --build=${BUILD}
make -j${CPU_COUNT} ${VERBOSE_AT}
make tests
make install
