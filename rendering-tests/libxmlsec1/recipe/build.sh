#!/bin/bash
# Get an updated config.sub and config.guess
cp $BUILD_PREFIX/share/gnuconfig/config.* .

# xml2-config add -lz and -llzma to the linker flags, resulting in overlinking
# only libxml2 needs to be linked
export LIBXML_LIBS="-lxml2"

./configure \
    --prefix=$PREFIX \
    --enable-shared \
    --enable-static=no \
    --disable-docs \
    --disable-ripemd160 \
    --with-openssl="${PREFIX}" \
    --with-libxml="${PREFIX}" \
    --with-xslt="${PREFIX}" \
    --with-gcrypt="${PREFIX}"

make -j${CPU_COUNT} ${VERBOSE_AT}
if [[ "${CONDA_BUILD_CROSS_COMPILATION:-}" != "1" || "${CROSSCOMPILING_EMULATOR}" != "" ]]; then
make check
fi
make install
