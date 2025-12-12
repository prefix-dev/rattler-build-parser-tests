set -ex

mkdir build
pushd build

# ENABLE_LIBDIR_IN_RUNTIME_SEARCH=ON
# help VPL find runtimes within the conda-forge environment.
# https://github.com/intel/libvpl/issues/119
cmake \
    ${CMAKE_ARGS} \
    -DENABLE_LIBDIR_IN_RUNTIME_SEARCH=ON \
    -DINSTALL_EXAMPLES=OFF \
    ..

make -j${CPU_COUNT}

make install
