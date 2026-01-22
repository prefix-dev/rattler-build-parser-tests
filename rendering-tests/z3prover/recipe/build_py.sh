#!/usr/bin/env bash

set -xe

mkdir -p build_py && cd build_py

cmake -G "Ninja" \
    ${CMAKE_ARGS} \
    -DCMAKE_INSTALL_PYTHON_PKG_DIR=${SP_DIR} \
    -DPython3_EXECUTABLE=${BUILD_PREFIX}/bin/python \
    -DZ3_BUILD_DOCUMENTATION=FALSE \
    -DZ3_BUILD_LIBZ3_CORE=OFF \
    -DZ3_BUILD_LIBZ3_SHARED=TRUE \
    -DZ3_BUILD_PYTHON_BINDINGS=TRUE \
    -DZ3_ENABLE_EXAMPLE_TARGETS=OFF \
    -DZ3_INCLUDE_GIT_DESCRIBE=FALSE \
    -DZ3_INCLUDE_GIT_HASH=FALSE \
    -DZ3_INSTALL_PYTHON_BINDINGS=TRUE \
    ..
ninja install

cd "${SRC_DIR}/src/api/python"
"${PYTHON}" -m pip install . --no-deps --no-build-isolation --disable-pip-version-check
