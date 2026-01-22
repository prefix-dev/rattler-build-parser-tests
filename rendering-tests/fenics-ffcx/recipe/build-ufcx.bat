setlocal EnableDelayedExpansion

cmake -G "NMake Makefiles" ^
  %CMAKE_ARGS% ^
  -DCMAKE_BUILD_TYPE=Release ^
  -DCMAKE_INSTALL_PREFIX="%PREFIX%" ^
  -B build-dir ^
  -S cmake/

if errorlevel 1 exit 1

cmake --build build-dir
if errorlevel 1 exit 1

cmake --install build-dir
if errorlevel 1 exit 1
