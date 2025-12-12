set -ex


cmake ${CMAKE_ARGS} -S ${SRC_DIR} -B build \
-GNinja \
-DCMAKE_BUILD_TYPE=Release \
-DCMAKE_INSTALL_PREFIX=$PREFIX \
-DCMAKE_INSTALL_LIBDIR=lib \
-DBUILD_SHARED_LIBS=ON 

cmake --build build -j $CPU_COUNT

if [[ "${CONDA_BUILD_CROSS_COMPILATION:-}" != "1" || "${CROSSCOMPILING_EMULATOR}" != "" ]]; then
ctest --output-on-failure
fi

cmake --install build
