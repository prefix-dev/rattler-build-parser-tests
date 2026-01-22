#!/bin/bash

cmake ${CMAKE_ARGS} \
      -DBUILD_SHARED_LIBS=ON \
      -DCMAKE_INSTALL_PREFIX=$PREFIX \
      -DCMAKE_INSTALL_LIBDIR=lib \
      -S $SRC_DIR -B build
cmake --build build --config Release
cmake --install build --config Release

if [[ "$CONDA_BUILD_CROSS_COMPILATION" != "1" ]]; then
  cd build
  ctest -C Release
fi
