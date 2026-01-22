#!/bin/sh

Python_INCLUDE_DIR="$(python -c 'import sysconfig; print(sysconfig.get_path("include"))')"
Python_NumPy_INCLUDE_DIR="$(python -c 'import numpy;print(numpy.get_include())')"
CMAKE_ARGS="${CMAKE_ARGS} -DPython_EXECUTABLE:PATH=${PYTHON}"
CMAKE_ARGS="${CMAKE_ARGS} -DPython_INCLUDE_DIR:PATH=${Python_INCLUDE_DIR}"
CMAKE_ARGS="${CMAKE_ARGS} -DPython_NumPy_INCLUDE_DIR=${Python_NumPy_INCLUDE_DIR}"
CMAKE_ARGS="${CMAKE_ARGS} -DPython3_EXECUTABLE:PATH=${PYTHON}"
CMAKE_ARGS="${CMAKE_ARGS} -DPython3_INCLUDE_DIR:PATH=${Python_INCLUDE_DIR}"
CMAKE_ARGS="${CMAKE_ARGS} -DPython3_NumPy_INCLUDE_DIR=${Python_NumPy_INCLUDE_DIR}"

SITEPKG_REL="$(python -c 'import sysconfig,sys,os; print(os.path.relpath(sysconfig.get_paths()["purelib"], sys.prefix))')"

# The generation process of .pyi files using doxystub is inheritly incompatible with cross-compilation,
# as it uses to run the Python interpreter and load the module itself. However the generated .pyi
# file is cross-platform, so during cross-compilation we actually build the host placo, and we use that
# one to generate the .pyi that we then use then for the actual build
if [[ "$CONDA_BUILD_CROSS_COMPILATION" == 1 ]]; then
  (
    mkdir -p build_cxx_host
    pushd build_cxx_host

    export CC_BACKUP=$CC
    export CXX_BACKUP=$CXX
    export LDFLAGS_BACKUP=$LDFLAGS
    export PKG_CONFIG_PATH_BACKUP=$PKG_CONFIG_PATH

    export CC=$CC_FOR_BUILD
    export CXX=$CXX_FOR_BUILD
    export LDFLAGS=${LDFLAGS//$PREFIX/$BUILD_PREFIX}
    export PKG_CONFIG_PATH=${PKG_CONFIG_PATH//$PREFIX/$BUILD_PREFIX}

    # Unset them as we're ok with builds that are either slow or non-portable
    unset CFLAGS
    unset CXXFLAGS

    cmake -GNinja .. \
      -DCMAKE_BUILD_TYPE=Release \
      -DCMAKE_PREFIX_PATH=$BUILD_PREFIX -DCMAKE_INSTALL_PREFIX=$BUILD_PREFIX \
      -DCMAKE_INSTALL_LIBDIR=lib \
      -DBUILD_TESTING:BOOL=OFF
    cmake --build . --parallel ${CPU_COUNT} --config Release

    export CC=$CC_BACKUP
    export CXX=$CXX_BACKUP
    export LDFLAGS=$LDFLAGS_BACKUP
    export PKG_CONFIG_PATH=$PKG_CONFIG_PATH_BACKUP
  )
fi

if [[ "$CONDA_BUILD_CROSS_COMPILATION" == 1 ]]; then
  export CMAKE_ARGS="${CMAKE_ARGS} -DPLACO_PY_TO_INSTALL=$(pwd)/build_cxx_host/${SITEPKG_REL}/placo.pyi"
fi

rm -rf build
mkdir -p build

cd build

cmake ${CMAKE_ARGS} -GNinja -DPYTHON_EXECUTABLE=$PYTHON .. -DBUILD_TESTING:BOOL=ON

cmake --build . --config Release
cmake --build . --config Release --target install

if [[ "${CONDA_BUILD_CROSS_COMPILATION:-}" != "1" || "${CROSSCOMPILING_EMULATOR:-}" != "" ]]; then
  ctest --output-on-failure -C Release
fi

# The METADATA file is necessary to ensure that pip list shows the pip package installed by conda
# The INSTALLER file is necessary to ensure that pip list shows that the package is installed by conda
# See https://packaging.python.org/specifications/recording-installed-packages/
# and https://packaging.python.org/en/latest/specifications/core-metadata/#core-metadata

mkdir $SP_DIR/placo-$PKG_VERSION.dist-info

cat > $SP_DIR/placo-$PKG_VERSION.dist-info/METADATA <<METADATA_FILE
Metadata-Version: 2.1
Name: placo
Version: $PKG_VERSION
Summary: Rhoban Planning and Control
METADATA_FILE

cat > $SP_DIR/placo-$PKG_VERSION.dist-info/INSTALLER <<INSTALLER_FILE
conda
INSTALLER_FILE
