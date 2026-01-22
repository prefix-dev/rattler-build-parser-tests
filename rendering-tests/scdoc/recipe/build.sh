#!/usr/bin/env bash

set -o xtrace -o nounset -o pipefail -o errexit

if [[ ${CONDA_BUILD_CROSS_COMPILATION:-0} == 1 ]]; then
    CROSS_LDFLAGS=${LDFLAGS}
    CROSS_CC="${CC}"
    CROSS_LD="${LD}"

    LDFLAGS=${LDFLAGS//${PREFIX}/${BUILD_PREFIX}}
    CC=${CC_FOR_BUILD}
    unset LD

    make install LDFLAGS="${LDFLAGS}" PREFIX=${BUILD_PREFIX}
    make clean

    LDFLAGS="${CROSS_LDFLAGS}"
    CC=${CROSS_CC}
    LD=${CROSS_LD}

    sed -i "s?\$(HOST_SCDOC) <?${BUILD_PREFIX}/bin/scdoc <?" Makefile
fi

make install LDFLAGS="${LDFLAGS}" PREFIX=${PREFIX}
