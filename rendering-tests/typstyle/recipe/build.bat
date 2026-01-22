set CARGO_PROFILE_RELEASE_STRIP=symbols
set CARGO_PROFILE_RELEASE_LTO=fat

cd .\crates\typstyle
cargo install --no-track --locked --root "%PREFIX%" --path . || goto :error
cargo-bundle-licenses ^
    --format yaml ^
    --output THIRDPARTY_LICENSES.yaml || goto :error

goto :EOF

:error
echo Failed with error #%errorlevel%.
exit 1
