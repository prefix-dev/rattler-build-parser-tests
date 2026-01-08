@echo on

set CARGO_PROFILE_RELEASE_STRIP=symbols
set CARGO_PROFILE_RELEASE_LTO=fat

cargo-bundle-licenses ^
    --format yaml ^
    --output THIRDPARTY.yml || goto :error

:: build statically linked binary with Rust
set LIBCLANG_PATH=%LIBRARY_PREFIX%\lib
set PYO3_PYTHON=%PYTHON%

cargo install --features all_features --bins --no-track --locked --root %LIBRARY_PREFIX% --path . || goto :error

goto :eof

:error
echo Failed with error #%errorlevel%.
exit 1
