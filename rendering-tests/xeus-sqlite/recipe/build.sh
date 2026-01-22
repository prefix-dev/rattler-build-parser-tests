#!/bin/bash

if [[ ${target_platform} == linux-ppc64le ]]; then
  cmake -DCMAKE_BUILD_TYPE=Release     \
        -DCMAKE_INSTALL_PREFIX=$PREFIX \
        -DCMAKE_PREFIX_PATH=$PREFIX    \
        -DCMAKE_INSTALL_LIBDIR=lib     \
        -DXSQL_DISABLE_TUNE_GENERIC=ON \
        $SRC_DIR
else
  cmake -DCMAKE_BUILD_TYPE=Release     \
        -DCMAKE_INSTALL_PREFIX=$PREFIX \
        -DCMAKE_PREFIX_PATH=$PREFIX    \
        -DCMAKE_INSTALL_LIBDIR=lib     \
        -DXSQL_DISABLE_ARCH_NATIVE=ON  \
        $SRC_DIR
fi

make install
