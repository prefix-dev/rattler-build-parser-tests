:: MSVC is preferred.
set CC=cl.exe
set CXX=cl.exe

mkdir build
cd build
cmake ^
    -G "NMake Makefiles" ^
    -D CMAKE_INSTALL_PREFIX=%LIBRARY_PREFIX% ^
    -D CMAKE_BUILD_TYPE=Release ^
    -D BUILD_TESTING=FALSE ^
    -DAPPEND_PROJECT_NAME_TO_INCLUDEDIR:BOOL=OFF ^
    %SRC_DIR%
if errorlevel 1 exit 1

cmake --build . --config Release --target install
if errorlevel 1 exit 1
