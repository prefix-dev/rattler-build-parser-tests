#!/bin/sh

mkdir build && cd build

cmake -GNinja ${CMAKE_ARGS} -DCMAKE_INSTALL_PREFIX=$PREFIX \
      -DCMAKE_PREFIX_PATH=$PREFIX \
      -DCMAKE_BUILD_TYPE=Release \
      -DCMAKE_INSTALL_LIBDIR=lib \
      -DBUILD_SHARED_LIBS=ON \
      -DUA_ENABLE_ENCRYPTION=OPENSSL \
      -DUA_ENABLE_HISTORIZING=ON \
      -DUA_NAMESPACE_ZERO=REDUCED \
      -DOPEN62541_VERSION=v${PKG_VERSION} \
      -DUA_ARCH_REMOVE_FLAGS="-Werror" \
      $SRC_DIR

cmake --build . --config Release
cmake --install . --config Release
