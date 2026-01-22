#!/bin/bash

if [[ "$(uname)" == "Darwin" ]]; then
    CXXFLAGS="${CXXFLAGS} -D_LIBCPP_DISABLE_AVAILABILITY"
fi

cmake -DCMAKE_BUILD_TYPE=Release     \
      -DCMAKE_INSTALL_PREFIX=$PREFIX \
      -DCMAKE_PREFIX_PATH=$PREFIX    \
      -DCMAKE_INSTALL_LIBDIR=lib     \
      -DXEUS_CPP_BUILD_TESTS=OFF     \
      $SRC_DIR

make install
