#!/bin/sh

export LIBCLANG_PATH=${PREFIX}/lib
export C_INCLUDE_PATH=${PREFIX}/include
export CPLUS_INCLUDE_PATH=${PREFIX}/include

#export BINDGEN_EXTRA_CLANG_ARGS="\
#    --sysroot=${PREFIX} \
#    -I${PREFIX}/include \
#    ${CFLAGS}"
#
## For arm64 macOS cross-compile specifically
#if [[ "$target_platform" == "osx-arm64" ]]; then
#    export BINDGEN_EXTRA_CLANG_ARGS="${BINDGEN_EXTRA_CLANG_ARGS} --target=aarch64-apple-darwin"
#fi
#
echo "***** PLATFORM *****"
echo "target_platform=${target_platform}"
echo "build_platform=${build_platform}"
echo "PREFIX=${PREFIX}"
echo "BUILD_PREFIX=${BUILD_PREFIX}"
echo "LIBCLANG_PATH=${LIBCLANG_PATH}"

echo "CC: $CC"
echo "CXX: $CXX"
$CC --version
$CXX --version

echo "=== Searching for libclang.dylib ==="
find "${BUILD_PREFIX}" -name "libclang.dylib" 2>/dev/null || echo "Not in BUILD_PREFIX"
find "${PREFIX}" -name "libclang.dylib" 2>/dev/null || echo "Not in PREFIX"
find "${CONDA_PREFIX}" -name "libclang.dylib" 2>/dev/null || echo "Not in CONDA_PREFIX"

# Check what's in the expected location
echo "=== Contents of BUILD_PREFIX/lib ==="
ls -la "${BUILD_PREFIX}/lib" | grep -i clang || echo "No clang libraries found"

# Set and verify
echo "=== LIBCLANG_PATH set to: ${LIBCLANG_PATH} ==="

# Check if the file exists where we pointed
if [[ -f "${LIBCLANG_PATH}/libclang.dylib" ]]; then
    echo "✓ Found libclang.dylib"
    ls -lh "${LIBCLANG_PATH}/libclang.dylib"
else
    echo "✗ libclang.dylib NOT found at ${LIBCLANG_PATH}"
fi

echo "=== Searching for libpython ==="
find "${BUILD_PREFIX}" -name "libpython*" 2>/dev/null || echo "Not in BUILD_PREFIX"
find "${PREFIX}" -name "libpython*" 2>/dev/null || echo "Not in PREFIX"
find "${CONDA_PREFIX}" -name "libpython*" 2>/dev/null || echo "Not in CONDA_PREFIX"

if [[ "$target_platform" == "osx-arm64" ]]
then
	#export PYO3_CROSS_LIB_DIR=${PREFIX}/lib
	#export CARGO_TARGET_AARCH64_APPLE_DARWIN_LINKER=${CC}
	#export RUSTFLAGS="-C linker=${CC}"
	export RUSTFLAGS="-C link-arg=-Wl,-undefined,dynamic_lookup"
	export LIBCLANG_PATH="${BUILD_PREFIX}/lib"
	export LIBRARY_PATH="${LIBRARY_PATH}:${PREFIX}/lib"
else
	export LIBRARY_PATH=${LIBRARY_PATH}:${PREFIX}/lib
fi
export LDFLAGS="${LDFLAGS} -L${PREFIX}/lib"
# export RUSTFLAGS="${RUSTFLAGS} -L${PREFIX/lib}"
# find ${PREFIX} -name 'libpython*'
# For macOS cross-compilation, point to the correct Python library
# export PYO3_CROSS_LIB_DIR="${PREFIX}/lib"

#if [[ ${target_platform} =~ .*linux.* ]]; then
#    ln -sf ${PREFIX}/lib/libglib-2.0.so.0 ${PREFIX}/lib/libglib-2.0.so
#fi
#./gen_stub


#echo "****** LIBINFO ******"
#file -L "${PREFIX}/libpython*"
$PYTHON -m pip install . -vv --no-deps --no-build-isolation

cargo-bundle-licenses --format yaml --output THIRDPARTY.yml

