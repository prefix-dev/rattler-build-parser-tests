#!/bin/bash

set -exo pipefail

export CXXFLAGS="${CXXFLAGS} -fpermissive -std=c++17"

# Build prqlc-c library in advance
cd src/third-party/prqlc-c
cargo-bundle-licenses --format yaml --output ${SRC_DIR}/THIRDPARTY.yml
cargo build --release
cd ${SRC_DIR}
PRQLC_DIR=${SRC_DIR}/src/third-party/prqlc-c/target
mkdir -p ${PRQLC_DIR}/release
find "${PRQLC_DIR}" -type f \( -name 'libprqlc_c.a' -o -name 'libprqlc_c.d' \) \
    -exec cp {} "${PRQLC_DIR}/release/" \;

./configure \
    --prefix=${PREFIX} \
    --with-sqlite3=${PREFIX} \
    --with-readline=${PREFIX} \
    --with-libarchive=${PREFIX} \
    --with-ncurses=${PREFIX} \
    --with-pcre2=${PREFIX} \
    --with-libcurl=${PREFIX} \
    --with-jemalloc=${PREFIX} \
    --disable-dependency-tracking \
    --disable-silent-rules

make -j${CPU_COUNT} V=1
make install
