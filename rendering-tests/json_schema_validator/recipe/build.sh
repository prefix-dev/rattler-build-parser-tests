#! /bin/bash

mkdir builddir
pushd builddir
cmake .. \
  ${CMAKE_ARGS} \
  -GNinja \
  -DBUILD_SHARED_LIBS=ON \
  -DJSON_VALIDATOR_BUILD_SHARED_LIBS=ON \
  -DJSON_VALIDATOR_BUILD_EXAMPLES=OFF \
  -DJSON_VALIDATOR_BUILD_TESTS=OFF

ninja
ninja install
