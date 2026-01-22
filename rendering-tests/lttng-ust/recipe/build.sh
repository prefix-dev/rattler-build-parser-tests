./configure --prefix="${PREFIX}" --disable-man-pages --disable-numa
make
make check
make install
