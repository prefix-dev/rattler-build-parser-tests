#!/usr/bin/env bash

set -o xtrace -o nounset -o pipefail -o errexit

if [[ ${CONDA_BUILD_CROSS_COMPILATION:-0} == 1 ]]; then
    echo ac_cv_posix1_2008_realpath=yes > ${SRC_DIR}/config.site
    export CONFIG_SITE=${SRC_DIR}/config.site
fi

./configure --disable-debug \
    --disable-dependency-tracking \
    --prefix=${PREFIX} \
    --libdir=${PREFIX}/lib \
    --sysconfdir=${PREFIX}/etc \
    --with-ncurses=${PREFIX} \
    --with-sqlite3=${PREFIX} \
    --with-universal-ctags=${PREFIX}/bin/ctags

make -j${CPU_COUNT} check
make -j${CPU_COUNT} install

mkdir -p ${PREFIX}/etc
install -m 644 gtags.conf ${PREFIX}/etc
