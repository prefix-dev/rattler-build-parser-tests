@echo on

set CARGO_PROFILE_RELEASE_STRIP=symbols
set CARGO_PROFILE_RELEASE_LTO=fat

:: check licenses
cargo-bundle-licenses --format yaml --output THIRDPARTY.yml

:: build
cargo install --locked  --root "%LIBRARY_PREFIX%" --path . --no-track || goto :error

goto :EOF

:error
echo Failed with error #%errorlevel%.
exit 1
