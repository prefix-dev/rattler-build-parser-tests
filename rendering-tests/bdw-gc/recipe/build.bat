cmake %CMAKE_ARGS% ^
  -G Ninja ^
  -DBUILD_SHARED_LIBS=ON ^
  -Dbuild_tests=ON
if errorlevel 1 exit 1

ninja -j%CPU_COUNT%
if errorlevel 1 exit 1

ninja install
if errorlevel 1 exit 1

ctest
if errorlevel 1 exit 1

