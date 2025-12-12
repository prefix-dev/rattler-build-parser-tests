# configure has a weird choice the ignores LDFLAGS
export CFLAGS="${CFLAGS} ${LDFLAGS}"

# Get an updated config.sub and config.guess
tarball=$(ls -1d ./cfitsio-*)
tar -xzvf ${tarball}
rm -f ${tarball}
cfitsio=$(ls -1d ./cfitsio-*)
cp $BUILD_PREFIX/share/libtool/build-aux/config.* ${cfitsio}
patch ${cfitsio}/Makefile.in ${RECIPE_DIR}/no-programs-0000.patch

$PYTHON -m pip install . --no-deps --ignore-installed --no-cache-dir -vvv
