@echo off
setlocal enabledelayedexpansion

REM Test libjxl compile and link
echo === Testing compile/link for libjxl ===
echo #include ^<jxl/decode.h^> > conftest.c
echo int main(void){(void)JxlDecoderVersion();return 0;}>> conftest.c

for /f "usebackq delims=" %%i in (`pkg-config --cflags libjxl`) do set "JXL_CFLAGS=%%i"
for /f "usebackq delims=" %%i in (`pkg-config --libs libjxl`) do set "JXL_LIBS=%%i"

echo CFLAGS: !JXL_CFLAGS!
echo LIBS: !JXL_LIBS!

clang.exe !JXL_CFLAGS! conftest.c !JXL_LIBS! -o conftest.exe
if errorlevel 1 exit /b 1

conftest.exe
if errorlevel 1 exit /b 1
echo === libjxl compile/link test passed ===

REM Test libjxl_threads compile and link
echo === Testing compile/link for libjxl_threads ===
echo #include ^<jxl/thread_parallel_runner.h^> > conftest_threads.c
echo int main(void){(void)JxlThreadParallelRunner;return 0;}>> conftest_threads.c

for /f "usebackq delims=" %%i in (`pkg-config --cflags libjxl_threads`) do set "JXL_THREADS_CFLAGS=%%i"
for /f "usebackq delims=" %%i in (`pkg-config --libs libjxl_threads`) do set "JXL_THREADS_LIBS=%%i"

echo CFLAGS: !JXL_THREADS_CFLAGS!
echo LIBS: !JXL_THREADS_LIBS!

clang.exe !JXL_THREADS_CFLAGS! conftest_threads.c !JXL_THREADS_LIBS! -o conftest_threads.exe
if errorlevel 1 exit /b 1

conftest_threads.exe
if errorlevel 1 exit /b 1
echo === libjxl_threads compile/link test passed ===
