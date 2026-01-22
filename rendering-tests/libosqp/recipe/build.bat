@echo on

mkdir build
cd build

:: Initially configure with OSQP_USE_BUNDLED_QDLDL ON to run tests.
:: While we can link against the libosqp shared library, it causes
:: issues on Windows, because the tests use a lot of symbols that
:: are not exported. By statically linking against the bundled qdldl
:: library, we avoid this.
cmake -G "Ninja" ^
    %CMAKE_ARGS% ^
    -DOSQP_ALGEBRA_BACKEND=builtin ^
    -DOSQP_BUILD_UNITTESTS:BOOL=ON ^
    -DOSQP_BUILD_SHARED_LIB:BOOL=OFF ^
    -DBUILD_SHARED_LIBS:BOOL=OFF ^
    -DOSQP_BUILD_STATIC_LIB:BOOL=ON ^
    -DOSQP_USE_BUNDLED_QDLDL:BOOL=ON ^
    -DOSQP_CODEGEN:BOOL=OFF ^
    %SRC_DIR%
if %ERRORLEVEL% neq 0 exit 1

:: Build.
cmake --build .
if %ERRORLEVEL% neq 0 exit 1

:: Test
if not "%CONDA_BUILD_CROSS_COMPILATION%" == "1" (
    cmake --build . --target test
    if %ERRORLEVEL% neq 0 exit 1

    .\out\osqp_simple_demo
    if %ERRORLEVEL% neq 0 exit 1

    .\out\osqp_demo
    if %ERRORLEVEL% neq 0 exit 1
)

:: Re-configure to dynamically link qdldl and build shared library
cmake -DBUILD_SHARED_LIBS=ON ^
    -DOSQP_BUILD_SHARED_LIB=ON ^
    -DOSQP_BUILD_STATIC_LIB=OFF ^
    -DOSQP_BUILD_UNITTESTS=OFF ^
    -DOSQP_BUILD_DEMO_EXE=OFF  ^
    -DOSQP_USE_BUNDLED_QDLDL:BOOL=OFF ^
    .
if %ERRORLEVEL% neq 0 exit 1

:: Install.
cmake --build . --target install
if %ERRORLEVEL% neq 0 exit 1
