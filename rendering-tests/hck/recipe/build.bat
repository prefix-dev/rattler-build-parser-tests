@echo on
@setlocal EnableDelayedExpansion

:: Check that all downstream libraries licenses are present
cargo-bundle-licenses --format yaml --output CI.THIRDPARTY.yml || goto :error

:: build
cargo install --bins --no-track --locked --root "%PREFIX%" --path . || goto :error

goto :eof

:error
echo Failed with error #%errorlevel%.
exit 1
