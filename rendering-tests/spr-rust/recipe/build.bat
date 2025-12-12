@echo on
@setlocal EnableDelayedExpansion

set OPENSSL_DIR=%LIBRARY_PREFIX%
set OPENSSL_NO_VENDOR=1
set CARGO_PROFILE_RELEASE_STRIP=symbols
set CARGO_PROFILE_RELEASE_LTO=fat

:: check licenses
cargo-bundle-licenses --format yaml --output THIRDPARTY.yml || goto :error

:: build
cargo install --bins --no-track --locked --root "%PREFIX%" --path . || goto :error

goto :eof

:error
echo Failed with error #%errorlevel%.
exit 1
