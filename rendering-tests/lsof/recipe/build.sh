#!/usr/bin/env bash

set -o xtrace -o nounset -o pipefail -o errexit

if [[ ${target_platform} =~ .*osx.* ]]; then
    export LSOF_INCLUDE="${CONDA_BUILD_SYSROOT}/usr/include"
fi
sed -i "s?/usr/include/??" lib/dialects/darwin/machine.h

mv 00README README
LSOF_CC="${CC} ${CPPFLAGS} ${CFLAGS} ${LDFLAGS}" \
    ./Configure -n $(uname|tr '[:upper:]' '[:lower:]')
make -j${CPU_COUNT}
mkdir -p $PREFIX/bin/
cp ./lsof $PREFIX/bin/
