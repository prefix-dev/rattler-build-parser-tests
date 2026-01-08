#!/bin/bash
cd IlmBase
mkdir build
cd build

cmake ${CMAKE_ARGS} -DCMAKE_INSTALL_PREFIX=$PREFIX \
      -DBUILD_SHARED_LIBS=ON \
      -DCMAKE_BUILD_TYPE=Release \
      -DILMBASE_LIB_SUFFIX="" \
      -DCMAKE_INSTALL_LIBDIR=lib \
      -GNinja \
      ..

ninja install