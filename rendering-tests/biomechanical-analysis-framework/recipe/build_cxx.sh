#!/bin/sh

rm -rf build
mkdir -p build

cd build

cmake ${CMAKE_ARGS} -GNinja .. \
    -DBUILD_TESTING:BOOL=ON \
    -DFRAMEWORK_COMPILE_tests:BOOL=ON \
    -DFRAMEWORK_COMPILE_examples:BOOL=OFF
cat CMakeCache.txt

cmake --build . --config Release
cmake --build . --config Release --target install

if [[ "${CONDA_BUILD_CROSS_COMPILATION:-}" != "1" || "${CROSSCOMPILING_EMULATOR:-}" != "" ]]; then
  ctest --output-on-failure -C Release
fi
