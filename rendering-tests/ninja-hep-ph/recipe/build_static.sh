#!/bin/bash

set -xe

export DISABLE_QUADMATH=false

# libquadmath not supported on macOS or aarch64
if [[ "$(uname)" == "Darwin" ]]; then
    export DISABLE_QUADMATH=true
fi
if [[ "${target_platform}" == linux-aarch64 ]]; then
    export DISABLE_QUADMATH=true
fi

# c.f. https://conda-forge.org/docs/maintainer/knowledge_base/#cross-compilation-examples
# Get an updated config.sub and config.guess
cp $BUILD_PREFIX/share/gnuconfig/config.* .

autoreconf --install

./configure --help

if [[ "${DISABLE_QUADMATH}" == true ]]; then
    echo -e "\n# libquadmath not supported on target platform ${target_platform} so disabling quadninja."
    if [[ "$(uname)" == "Darwin" ]]; then
        # Following https://github.com/mg5amcnlo/HEPToolsInstallers/blob/d56fe6c04242360076be533a653c187493ef1187/installNinja.sh#L18-L19
        ./configure \
            --prefix=$PREFIX \
            --enable-shared=no \
            --enable-static=yes \
            --enable-higher_rank \
            --disable-quadninja \
            --with-avholo="${FFLAGS} -lavh_olo -lgfortran" \
            FCINCLUDE="${FCINCLUDE} -I${PREFIX}/include/oneloop" \
            CXX="${CXX}" \
            CXXFLAGS="-O2 -fcx-fortran-rules -fno-exceptions -fno-rtti ${CXXFLAGS}" \
            CPPFLAGS="-DNINJA_NO_EXCEPTIONS -fPIC ${CPPFLAGS}" \
            LDFLAGS="-Wl,-no_compact_unwind ${LDFLAGS}" \
            LIBS="-lc++"
    else
        ./configure \
            --prefix=$PREFIX \
            --enable-shared=no \
            --enable-static=yes \
            --enable-higher_rank \
            --disable-quadninja \
            --with-avholo="${FFLAGS} -lavh_olo -lgfortran" \
            FCINCLUDE="${FCINCLUDE} -I${PREFIX}/include/oneloop" \
            CXXFLAGS="${CXXFLAGS}" \
            CPPFLAGS="-DNINJA_NO_EXCEPTIONS -fPIC ${CPPFLAGS}" \
            LDFLAGS="${LDFLAGS}"
    fi
else
    ./configure \
        --prefix=$PREFIX \
        --enable-shared=no \
        --enable-static=yes \
        --enable-higher_rank \
        --enable-quadninja \
        --with-avholo="${FFLAGS} -lavh_olo -lgfortran" \
        FCINCLUDE="${FCINCLUDE} -I${PREFIX}/include/oneloop" \
        CXXFLAGS="${CXXFLAGS}" \
        CPPFLAGS="-DNINJA_NO_EXCEPTIONS -fPIC ${CPPFLAGS}" \
        LDFLAGS="${LDFLAGS}"
fi

# Makefile is not parallel safe so can't use 'make --jobs="${CPU_COUNT}"'
make

# Skip ``make check`` when cross-compiling
if [[ "${CONDA_BUILD_CROSS_COMPILATION:-}" != "1" || "${CROSSCOMPILING_EMULATOR:-}" != "" ]]; then
  make check
fi
make install
make clean

unset DISABLE_QUADMATH
