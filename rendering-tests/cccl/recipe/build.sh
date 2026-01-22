#!/usr/bin/env bash

set -xeuo pipefail

mkdir build_release
pushd build_release

cmake ${CMAKE_ARGS} \
      -G "Ninja" \
      -DCMAKE_BUILD_TYPE:STRING=Release \
      -DCMAKE_INSTALL_PREFIX:PATH="${PREFIX}" \
      -DCMAKE_INSTALL_INCLUDEDIR:PATH="include/cccl" \
      -DCMAKE_INSTALL_LIBDIR:PATH="lib" \
      -DCCCL_ENABLE_UNSTABLE:BOOL=ON \
      -DCCCL_ENABLE_CUDAX:BOOL=ON \
      -Dcudax_ENABLE_INSTALL_RULES:BOOL=ON \
      -DCCCL_ENABLE_TESTING:BOOL=OFF \
      -DCUB_ENABLE_TESTING:BOOL=OFF \
      -DTHRUST_ENABLE_TESTING:BOOL=OFF \
      -DLIBCUDACXX_ENABLE_LIBCUDACXX_TESTS:BOOL=OFF \
      -Dcudax_ENABLE_TESTING:BOOL=OFF \
      "${SRC_DIR}"

cmake --build . --target install

popd
