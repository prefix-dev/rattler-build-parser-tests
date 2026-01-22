@echo on

cd compiler || goto :error

set CARGO_PROFILE_RELEASE_STRIP=symbols
set CARGO_PROFILE_RELEASE_LTO=fat
set OPENSSL_DIR=%LIBRARY_PREFIX%
set OPENSSL_NO_VENDOR=1

:: check licenses
cargo-bundle-licenses --format yaml --output %SRC_DIR%\THIRDPARTY.yml || goto :error

:: build
cargo install --bins --no-track --locked --root "%LIBRARY_PREFIX%" --path crates\relay-bin || goto :error

goto :EOF

:error
echo Failed with error #%errorlevel%.
exit 1
