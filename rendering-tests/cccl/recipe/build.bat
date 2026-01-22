@echo on

mkdir build_release
if errorlevel 1 exit 1

pushd build_release
if errorlevel 1 exit 1

cmake %CMAKE_ARGS% ^
      -G "Ninja" ^
      -DCMAKE_BUILD_TYPE:STRING=Release ^
      -DCMAKE_INSTALL_PREFIX:PATH=%LIBRARY_PREFIX% ^
      -DCMAKE_INSTALL_INCLUDEDIR:PATH=include/cccl ^
      -DCMAKE_INSTALL_LIBDIR:PATH=lib ^
      -DCCCL_ENABLE_UNSTABLE:BOOL=ON ^
      -DCCCL_ENABLE_CUDAX:BOOL=ON ^
      -Dcudax_ENABLE_INSTALL_RULES:BOOL=ON ^
      -DCCCL_ENABLE_TESTING:BOOL=OFF ^
      -DCUB_ENABLE_TESTING:BOOL=OFF ^
      -DTHRUST_ENABLE_TESTING:BOOL=OFF ^
      -DLIBCUDACXX_ENABLE_LIBCUDACXX_TESTS:BOOL=OFF ^
      -Dcudax_ENABLE_TESTING:BOOL=OFF ^
      "%SRC_DIR%"
if errorlevel 1 exit 1

cmake --build . --target install
if errorlevel 1 exit 1

popd
if errorlevel 1 exit 1
