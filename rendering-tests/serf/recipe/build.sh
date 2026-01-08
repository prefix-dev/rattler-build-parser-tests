#!/usr/bin/env bash
set -ex

if [ $CONDA_BUILD_CROSS_COMPILATION -eq 1 ]; then
  scons APR="${PREFIX}" APU="${PREFIX}" \
      OPENSSL="$PREFIX" ZLIB="$PREFIX" \
      PREFIX="$PREFIX" CC="$CC" \
      CFLAGS="$CFLAGS" \
      CPPFLAGS="$CPPFLAGS" LINKFLAGS="$LDFLAGS"
else 
  scons APR="${PREFIX}" APU="${PREFIX}" \
      OPENSSL="$PREFIX" ZLIB="$PREFIX" \
      PREFIX="$PREFIX" CC="$CC" \
      CFLAGS="$CFLAGS" \
      CPPFLAGS="$CPPFLAGS" LINKFLAGS="$LDFLAGS"
fi

scons install
