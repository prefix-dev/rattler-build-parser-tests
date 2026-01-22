REM For an unknwon reason cmake fails to parse correctly XEXTRA_JUPYTER_DATA_DIR=%PREFIX%\\share\\jupyter, so let's not use it and copy te kernelspec after
cmake -G "NMake Makefiles" ^
  -D CMAKE_BUILD_TYPE=Release ^
  -D CMAKE_INSTALL_PREFIX=%LIBRARY_PREFIX% ^
  %SRC_DIR%

if errorlevel 1 exit 1

nmake
if errorlevel 1 exit 1

nmake install
if errorlevel 1 exit 1

REM Copying kernelspec to the general prefix for Jupyter to pick it up.

md %PREFIX%\share\jupyter\kernels\xlua
xcopy %LIBRARY_PREFIX%\share\jupyter\kernels\xlua %PREFIX%\share\jupyter\kernels\xlua /F /Y
