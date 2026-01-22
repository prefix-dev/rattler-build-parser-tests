mkdir build
cd build

:: Ensure that M_PI is defined
set "CXXFLAGS=%CXXFLAGS% /D_USE_MATH_DEFINES"

:: Use clang-cl to avoid operator overloading confusion
set "CC=%BUILD_PREFIX%/Library/bin/clang-cl.exe"
set "CXX=%BUILD_PREFIX%/Library/bin/clang-cl.exe"

cmake %CMAKE_ARGS% -G "Ninja" ^
    -DCMAKE_WINDOWS_EXPORT_ALL_SYMBOLS:BOOL=ON ^
    -DBUILD_TESTING:BOOL=ON ^
    -DPYTHON_EXECUTABLE=%PYTHON% ^
    %SRC_DIR%
if errorlevel 1 exit 1

type CMakeCache.txt

:: As the .pyi generation uses doxystub that loads the placo module, the libplaco.dll
:: must be loadable by python. However, we can't simply add the build directory to PATH
:: as Python ignores the PATH, and we can even modify the doxystub command to call
:: os.add_dll_directory()
:: As a workaround, we first build libplaco.dll and we manually copy it to %LIBRARY_BIN%
cmake --build . --config Release --target libplaco
if errorlevel 1 exit 1

copy .\libplaco.dll "%LIBRARY_BIN%"
if errorlevel 1 exit 1

:: Build all targets, including Python bindings and .pyi files
cmake --build . --config Release --parallel 2
if errorlevel 1 exit 1

:: Install.
cmake --build . --config Release --target install
if errorlevel 1 exit 1

:: Test.
ctest --output-on-failure -C Release
if errorlevel 1 exit 1

REM The METADATA file is necessary to ensure that pip list shows the pip package installed by conda
REM The INSTALLER file is necessary to ensure that pip list shows that the package is installed by conda
REM See https://packaging.python.org/specifications/recording-installed-packages/
REM and https://packaging.python.org/en/latest/specifications/core-metadata/#core-metadata

mkdir "%SP_DIR%/placo-%PKG_VERSION%.dist-info"

set metadata_file=%SP_DIR%\placo-%PKG_VERSION%.dist-info\METADATA
echo>%metadata_file% Metadata-Version: 2.1
echo>>%metadata_file% Name: placo
echo>>%metadata_file% Version: %PKG_VERSION%
echo>>%metadata_file% Summary: Rhoban Planning and Control

set installer_file=%SP_DIR%\placo-%PKG_VERSION%.dist-info\INSTALLER
echo>%installer_file% conda

