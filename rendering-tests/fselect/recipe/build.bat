@set echo
@setlocal EnableDelayedExpansion

set CARGO_PROFILE_RELEASE_STRIP=symbols
set CARGO_PROFILE_RELEASE_LTO=fat
set OPENSSL_DIR=%LIBRARY_PREFIX%
set OPENSSL_NO_VENDOR=1

copy %BUILD_PREFIX%\Library\lib\libssh2.lib %BUILD_PREFIX%\Library\lib\ssh2.lib

:: check licenses
cargo-bundle-licenses ^
    --format yaml ^
    --output THIRDPARTY.yml || goto :error

:: build statically linked binary with Rust
cargo install --bins --no-track --locked --root %LIBRARY_PREFIX% --path . || goto :error

goto :eof

:error
echo Failed with error #%errorlevel%.
exit 1
