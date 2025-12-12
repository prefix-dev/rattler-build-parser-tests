#!/bin/bash

set -ex
if [ "$(uname)" == "Linux" ]
then
   export LDFLAGS="$LDFLAGS -Wl,-rpath-link,${PREFIX}/lib"
fi

if [[ "${target_platform}" == "osx-64" ]]; then
  # See https://conda-forge.org/docs/maintainer/knowledge_base.html#newer-c-features-with-old-sdk
  export CXXFLAGS="${CXXFLAGS} -D_LIBCPP_DISABLE_AVAILABILITY"
fi


mkdir build
cd build
cmake -G "Ninja" \
      ${CMAKE_ARGS} \
      -DCMAKE_INSTALL_PREFIX:PATH="${PREFIX}" \
      -DCMAKE_BUILD_TYPE:STRING=Release \
      -DCMAKE_LIBRARY_PATH="${PREFIX}/lib" \
      -DCMAKE_INCLUDE_PATH="${PREFIX}/include" \
      -DWITH_TESTS=OFF \
      -DWITH_ZSTD=OFF \
      ..

# CircleCI offers two cores.
ninja
ninja install
