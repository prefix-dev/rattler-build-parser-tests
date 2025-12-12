#!/bin/bash

CXXFLAGS="${CXXFLAGS} -D_LIBCPP_DISABLE_AVAILABILITY"

cmake -G "Ninja" \
      ${CMAKE_ARGS} \
      -D CMAKE_BUILD_TYPE=Release     \
      -D CMAKE_INSTALL_PREFIX=$PREFIX \
      -D CMAKE_INSTALL_LIBDIR=lib     \
      $SRC_DIR

cmake --build . --config Release -- -j$CPU_COUNT
cmake --build . --config Release --target install
