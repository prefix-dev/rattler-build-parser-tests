@echo on

set CARGO_PROFILE_RELEASE_STRIP=symbols
set CARGO_PROFILE_RELEASE_LTO=fat

:: build
cargo install --locked ^
    --bins ^
    --no-track ^
    --root "%PREFIX%" ^
    --path sqlx-cli ^
    || exit 1

:: dump licenses
cargo-bundle-licenses ^
    --format yaml ^
    --output "%SRC_DIR%\THIRDPARTY.yml" ^
    || exit 1
