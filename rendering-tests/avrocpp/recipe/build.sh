#!/bin/bash

set -euxo pipefail

if [[ "${target_platform}" == osx-* ]]; then
    # See https://conda-forge.org/docs/maintainer/knowledge_base.html#newer-c-features-with-old-sdk
    CXXFLAGS="${CXXFLAGS} -D_LIBCPP_DISABLE_AVAILABILITY"
fi

cmake \
  ${CMAKE_ARGS} \
  -S lang/c++ \
  -B build \
  -G Ninja \
  -DBOOST_ROOT=$PREFIX \
  -DSNAPPY_ROOT_DIR=$PREFIX \
  -DCMAKE_BUILD_TYPE=RelWithDebInfo \
  -DBUILD_SHARED_LIBS=ON \
  -DCMAKE_CXX_STANDARD=17 \
  -DCMAKE_CXX_STANDARD_REQUIRED=ON \
  -DCMAKE_CXX_EXTENSIONS=OFF \
  -DCMAKE_VERBOSE_MAKEFILE=ON

cmake --build build --config RelWithDebInfo
cmake --build build --config RelWithDebInfo --target test
cmake --build build --config RelWithDebInfo --target install
