#!/usr/bin/env bash

set -o xtrace -o nounset -o pipefail -o errexit

if [[ ${CONDA_BUILD_CROSS_COMPILATION:-0} == 1 ]]; then
    BOOTSTRAP_CMAKE_ARGS=${CMAKE_ARGS//${PREFIX}/${BUILD_PREFIX}}
    BOOTSTRAP_CMAKE_ARGS=${BOOTSTRAP_CMAKE_ARGS//${CONDA_TOOLCHAIN_HOST}/${CONDA_TOOLCHAIN_BUILD}}

    CROSS_LDFLAGS=${LDFLAGS}
    CROSS_CXXFLAGS=${CXXFLAGS}
    CROSS_CC="${CC}"
    CROSS_CXX="${CXX}"
    CROSS_LD="${LD}"

    LDFLAGS=${LDFLAGS//${PREFIX}/${BUILD_PREFIX}}
    CXXFLAGS=${CXXFLAGS//${PREFIX}/${BUILD_PREFIX}}
    CC=${CC//${CONDA_TOOLCHAIN_HOST}/${CONDA_TOOLCHAIN_BUILD}}
    CXX=${CXX//${CONDA_TOOLCHAIN_HOST}/${CONDA_TOOLCHAIN_BUILD}}
    LD="${LD//${CONDA_TOOLCHAIN_HOST}/${CONDA_TOOLCHAIN_BUILD}}"

    cmake -S . -B build_host \
        -DCMAKE_POLICY_VERSION_MINIMUM=3.5 \
        -DCMAKE_BUILD_TYPE=Release \
        ${BOOTSTRAP_CMAKE_ARGS}
    cmake --build build_host
    cmake --install build_host

    LDFLAGS="${CROSS_LDFLAGS}"
    CXXFLAGS="${CROSS_CXXFLAGS}"
    CC=${CROSS_CC}
    CXX=${CROSS_CXX}
    LD=${CROSS_LD}

    sed -i -e "s,COMMAND \${CMAKE_CURRENT_BINARY_DIR}/\${LIB_NAME},COMMAND ${BUILD_PREFIX}/bin/tidy,g" ${SRC_DIR}/CMakeLists.txt
fi


cmake -S . -B build_target \
    -DCMAKE_POLICY_VERSION_MINIMUM=3.5 \
    -DCMAKE_BUILD_TYPE=Release \
    ${CMAKE_ARGS}
cmake --build build_target
cmake --install build_target
