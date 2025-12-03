#!/bin/sh

rm -rf build
mkdir build
cd build

cmake ${CMAKE_ARGS} -GNinja .. \
      -DCMAKE_BUILD_TYPE=Release \
      -DBUILD_TESTING:BOOL=ON

cmake --build . --config Release
cmake --build . --config Release --target install
if [[ "${CONDA_BUILD_CROSS_COMPILATION:-}" != "1" || "${CROSSCOMPILING_EMULATOR}" != "" ]]; then
  # test_QuaternionUtils  excluded for https://github.com/conda-forge/bayes-filters-lib-feedstock/issues/
  ctest --output-on-failure -C Release -E "test_QuaternionUtils"
fi
