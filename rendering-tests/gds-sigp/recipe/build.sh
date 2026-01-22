#!/bin/sh
set -e -x
echo %PREFIX%
mkdir build
cd build

cmake ${CMAKE_ARGS} \
      -DCMAKE_BUILD_TYPE=Release \
      ${SRC_DIR}

cmake --build . -j 8 --config Release --target install

if [[ $target_platform == $build_platform ]]
then
	ctest --output-on-failure
fi
