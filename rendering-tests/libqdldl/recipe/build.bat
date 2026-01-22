mkdir build
cd build

:: Initially configure with QDLDL_BUILD_STATIC_LIB ON to run tests
cmake ^
    -G "NMake Makefiles" ^
    -DCMAKE_INSTALL_PREFIX=%LIBRARY_PREFIX% ^
    -DCMAKE_BUILD_TYPE=Release ^
    -DCMAKE_INSTALL_SYSTEM_RUNTIME_LIBS_SKIP=True ^
    -DBUILD_SHARED_LIBS=ON ^
    -DQDLDL_BUILD_SHARED_LIB=ON ^
    -DQDLDL_BUILD_STATIC_LIB=ON ^
    -DBUILD_TESTING=ON ^
    -DQDLDL_UNITTESTS=ON ^
    %SRC_DIR%
if errorlevel 1 exit 1

:: Build.
cmake --build . --config Release
if errorlevel 1 exit 1

:: Test
ctest --output-on-failure -C Release
if errorlevel 1 exit 1

:: Re-configure with QDLDL_BUILD_STATIC_LIB OFF to install only shared library
cmake -DQDLDL_BUILD_SHARED_LIB=ON -DQDLDL_BUILD_STATIC_LIB=OFF .
if errorlevel 1 exit 1

:: Install.
cmake --build . --config Release --target install
if errorlevel 1 exit 1
