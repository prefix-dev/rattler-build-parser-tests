pushd test

cmake %CMAKE_ARGS% .
if errorlevel 1 exit /b 1

cmake --build . --config Release
if errorlevel 1 exit /b 1

Release\hello_hpx.exe
if errorlevel 1 exit /b 1

cmake --install . --prefix hello
hello\bin\hello_hpx
if errorlevel 1 exit /b 1
