set CARGO_PROFILE_RELEASE_STRIP=symbols
set CARGO_PROFILE_RELEASE_LTO=fat

:: check licenses
cargo-bundle-licenses ^
    --format yaml ^
    --output THIRDPARTY.yml

:: build statically linked binary with Rust
cargo install --no-track --locked --root %LIBRARY_PREFIX% --path .

make -C contrib prefix=%LIBRARY_PREFIX% all
