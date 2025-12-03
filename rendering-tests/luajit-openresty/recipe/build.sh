#!/usr/bin/env bash

set -o xtrace -o nounset -o pipefail -o errexit

if [[ -n ${CONDA_BUILD_CROSS_COMPILATION-} ]]; then
    IFS="-" read -ra TRIPLE <<< "${CC}"
    ARCH=${TRIPLE[0]}
    CC_BASE=${TRIPLE[3]}
    make amalg PREFIX=${PREFIX} XCFLAGS=-DLUAJIT_ENABLE_GC64 CC=${CC_BASE} \
        HOST_CC=${CONDA_TOOLCHAIN_BUILD}-${CC_BASE} \
        CROSS="${CONDA_TOOLCHAIN_HOST}-" \
        TARGET_FLAGS="-arch ${ARCH} -isysroot ${CONDA_BUILD_SYSROOT}"
    make install PREFIX=${PREFIX} XCFLAGS=-DLUAJIT_ENABLE_GC64 CC=${CC_BASE} \
        HOST_CC=${CONDA_TOOLCHAIN_BUILD}-${CC_BASE} \
        CROSS="${CONDA_TOOLCHAIN_HOST}-" \
        TARGET_FLAGS="-arch ${ARCH} -isysroot ${CONDA_BUILD_SYSROOT}"
else
    make amalg PREFIX=${PREFIX} XCFLAGS=-DLUAJIT_ENABLE_GC64 CC=${CC}
    make install PREFIX=${PREFIX} XCFLAGS=-DLUAJIT_ENABLE_GC64 CC=${CC}
fi

ln -sf ${PREFIX}/lib/libluajit-5.1${SHLIB_EXT} ${PREFIX}/lib/libluajit${SHLIB_EXT}

# Remove empty directories
rm -rf ${PREFIX}/lib/lua
rm -rf ${PREFIX}/share/lua
rm -f ${PREFIX}/lib/libluajit-5.1.a
