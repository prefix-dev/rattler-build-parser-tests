@echo on
set CARGO_PROFILE_RELEASE_STRIP=symbols
set "OPENSSL_DIR=%LIBRARY_PREFIX%"

cd rudof_cli

cargo install ^
  --no-track ^
  --locked ^
  --path . ^
  --profile release ^
  --root "%PREFIX%" ^
  || exit 2

cargo-bundle-licenses ^
  --format yaml ^
  --output "%SRC_DIR%\THIRDPARTY.yml" ^
  || exit 3
