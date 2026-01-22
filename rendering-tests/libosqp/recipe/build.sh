#!/bin/sh
set -ex

mkdir build && cd build

# Initially configure with OSQP_USE_BUNDLED_QDLDL ON to run tests.
# While we can link against the libosqp shared library, it causes
# issues on Windows, because the tests use a lot of symbols that
# are not exported. By statically linking against the bundled qdldl
# library, we avoid this.
cmake -G Ninja \
    ${CMAKE_ARGS} \
    -DOSQP_ALGEBRA_BACKEND=builtin \
    -DOSQP_BUILD_UNITTESTS:BOOL=ON \
    -DOSQP_BUILD_SHARED_LIB:BOOL=OFF \
    -DBUILD_SHARED_LIBS:BOOL=OFF \
    -DOSQP_BUILD_STATIC_LIB:BOOL=ON \
    -DOSQP_USE_BUNDLED_QDLDL:BOOL=ON \
    -DOSQP_CODEGEN:BOOL=OFF \
    ${SRC_DIR}

# Build
cmake --build .

# Test
if [[ "${CONDA_BUILD_CROSS_COMPILATION:-0}" != 1 ]]; then
    mkdir -p ./testcodes/embedded1 ./testcodes/embedded2
    cmake --build . --target test

    ./out/osqp_simple_demo
    ./out/osqp_demo
fi

# Re-configure to dynamically link qdldl and build shared library
cmake -DBUILD_SHARED_LIBS=ON \
    -DOSQP_BUILD_SHARED_LIB=ON \
    -DOSQP_BUILD_STATIC_LIB=OFF \
    -DOSQP_BUILD_UNITTESTS=OFF \
    -DOSQP_BUILD_DEMO_EXE=OFF  \
    -DOSQP_USE_BUNDLED_QDLDL:BOOL=OFF \
    .

# Install
cmake --build . --target install
