#!/usr/bin/env bash

set -o xtrace -o nounset -o pipefail -o errexit

export LUA_INCLUDE_DIR=$PREFIX/include/luajit-2.1
export LUA_LIBRARY=$PREFIX/lib/libluajit-5.1${SHLIB_EXT}

cmake -S . -B build \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_PREFIX_PATH=$PREFIX \
    -DLUA_INCLUDE_DIR=$LUA_INCLUDE_DIR \
    -DLUA_LIBRARY=$LUA_LIBRARY \
    $CMAKE_ARGS
cmake --build build --config Release
cmake --install build

mkdir -p ${PREFIX}/lib/lua/5.1
ln -sf ${PREFIX}/lib/liblpeg${SHLIB_EXT} ${PREFIX}/lib/lua/5.1/lpeg.so
