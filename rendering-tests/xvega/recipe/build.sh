#!/bin/bash

if [[ ${target_platform} == linux-ppc64le ]]; then
  cmake -DCMAKE_BUILD_TYPE=Release       \
         -DXVEGA_BUILD_TESTS=OFF         \
         -DCMAKE_INSTALL_PREFIX=$PREFIX  \
         -DCMAKE_INSTALL_LIBDIR=lib      \
         -DXVEGA_DISABLE_TUNE_GENERIC=ON \
         $SRC_DIR
else
  cmake -DCMAKE_BUILD_TYPE=Release       \
         -DXVEGA_BUILD_TESTS=OFF         \
         -DCMAKE_INSTALL_PREFIX=$PREFIX  \
         -DCMAKE_INSTALL_LIBDIR=lib      \
         -DXVEGA_DISABLE_OPT_NATIVE=ON  \
         $SRC_DIR
fi

make -j ${CPU_COUNT} install
