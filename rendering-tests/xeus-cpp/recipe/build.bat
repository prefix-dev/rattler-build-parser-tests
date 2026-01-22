cmake -G "NMake Makefiles" -D CMAKE_BUILD_TYPE=Release -DCMAKE_PREFIX_PATH=%LIBRARY_PREFIX% -D CMAKE_INSTALL_PREFIX=%LIBRARY_PREFIX% -DXEUS_CPP_BUILD_TESTS=OFF %SRC_DIR%
if errorlevel 1 exit 1

nmake
if errorlevel 1 exit 1

nmake install
if errorlevel 1 exit 1
