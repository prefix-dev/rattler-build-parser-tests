@echo on

set CARGO_PROFILE_RELEASE_STRIP=symbols
set CARGO_PROFILE_RELEASE_LTO=fat
set OPENSSL_NO_VENDOR=1
set "OPENSSL_DIR=%LIBRARY_PREFIX%"

cargo install ^
    --bins ^
    --locked ^
    --no-track ^
    --path lychee-bin ^
    --profile release ^
    --root "%LIBRARY_PREFIX%" ^
    || exit 1

cargo-bundle-licenses ^
    --format yaml ^
    --output "%SRC_DIR%\THIRDPARTY.yml" ^
    || exit 2
