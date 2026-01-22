./autogen.sh
./configure --prefix=$PREFIX --enable-shared --disable-static --disable-dependency-tracking
make -j${CPU_COUNT}
make install
