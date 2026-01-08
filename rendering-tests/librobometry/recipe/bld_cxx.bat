mkdir build
cd build

:: BUILD_TESTING is disabled as a workaround for
:: https://github.com/robotology/ycm/issues/427
cmake ^
    -G "Ninja" ^
    -DCMAKE_INSTALL_PREFIX=%LIBRARY_PREFIX% ^
    -DCMAKE_BUILD_TYPE=Release ^
    -DBUILD_TESTING:BOOL=OFF ^
    -DBUILD_SHARED_LIBS:BOOL=ON ^
    -DROBOMETRY_USES_SYSTEM_nlohmann_json:BOOL=ON ^
    %SRC_DIR%
if errorlevel 1 exit 1

:: Build.
cmake --build . --config Release
if errorlevel 1 exit 1

:: Install.
cmake --build . --config Release --target install
if errorlevel 1 exit 1

:: Test.
ctest --output-on-failure -C Release 
if errorlevel 1 exit 1
