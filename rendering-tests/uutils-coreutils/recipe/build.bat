@echo on

:: dump licenses
cargo-bundle-licenses --format yaml --output THIRDPARTY.yml

for /f "usebackq delims=" %%A in (`where ln`) do set "LN=%%A" :: https://github.com/uutils/coreutils/issues/9244
for /f "usebackq delims=" %%A in (`where link`) do set "RUSTC_LINKER=%%A" :: https://github.com/conda-forge/uutils-coreutils-feedstock/pull/22

call :ConvertPath "%LN%" LN
call :ConvertPath "%PREFIX%" PREFIX
call :ConvertPath "%RUSTC_LINKER%" RUSTC_LINKER

:: build
set CARGO_BUILD_TARGET=
make PROFILE=release MULTICALL=y PREFIX="%PREFIX%" LN="%LN%" install || goto :error

goto :EOF

:error
echo Failed with error #%errorlevel%.
exit 1

:ConvertPath
:: convert Windows format path to Unix format
rem Parameter 1=[%1], Return name=[%2]
if %1 == "" ( echo %2 is empty & goto :error )
for /f "usebackq delims=" %%A in (`cygpath -u %1`) do set "%2=%%A"
exit /b 0
