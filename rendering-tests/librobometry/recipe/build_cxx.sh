#!/bin/sh

mkdir build
cd build

# BUILD_TESTING is disabled as a workaround for
# https://github.com/robotology/ycm/issues/427
cmake ${CMAKE_ARGS} -GNinja .. \
      -DCMAKE_BUILD_TYPE=Release \
      -DBUILD_TESTING:BOOL=OFF \
      -DROBOMETRY_USES_SYSTEM_nlohmann_json:BOOL=ON

cmake --build . --config Release
cmake --build . --config Release --target install
if [[ "${CONDA_BUILD_CROSS_COMPILATION:-}" != "1" || "${CROSSCOMPILING_EMULATOR}" != "" ]]; then
  ctest --output-on-failure -C Release
fi
