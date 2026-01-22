#!/bin/bash

set -ex

export CXXFLAGS="${CXXFLAGS} -std=c++11 -D_LIBCPP_DISABLE_AVAILABILITY"
if [ "$(uname)" == "Linux" ]; then
   export LDFLAGS="${LDFLAGS} -Wl,-rpath-link,${PREFIX}/lib"
fi

cmake ${CMAKE_ARGS} -G "Unix Makefiles" \
  -DCMAKE_BUILD_TYPE=Release \
  -DCMAKE_INSTALL_PREFIX=$PREFIX \
  -DCMAKE_LIBRARY_PATH=$PREFIX/lib \
  -DCMAKE_INCLUDE_PATH=$PREFIX/include \
  -DCONDA_BUILD=ON \
  .


# CircleCI offers two cores.
make -j $CPU_COUNT
make install
