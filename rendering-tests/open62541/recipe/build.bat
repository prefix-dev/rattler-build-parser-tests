mkdir build
cd build

cmake ^
    -G "Ninja" ^
    %CMAKE_ARGS% ^
    -DCMAKE_INSTALL_PREFIX=%LIBRARY_PREFIX% ^
    -DCMAKE_PREFIX_PATH=%LIBRARY_PREFIX% ^
    -DCMAKE_BUILD_TYPE=Release ^
    -DCMAKE_INSTALL_LIBDIR=lib ^
    -DBUILD_SHARED_LIBS=ON ^
    -DUA_ENABLE_ENCRYPTION=OPENSSL ^
    -DUA_ENABLE_HISTORIZING=ON ^
    -DUA_NAMESPACE_ZERO=REDUCED ^
    -DOPEN62541_VERSION=v%PKG_VERSION% ^
    -DUA_FORCE_WERROR:BOOL=OFF ^
    %SRC_DIR%
if errorlevel 1 exit 1

:: Build.
cmake --build . --config Release
if errorlevel 1 exit 1

:: Install.
cmake --build . --config Release --target install
if errorlevel 1 exit 1
