@echo on

:: uncomment for (slow) debuuging
:: set RUST_BACKTRACE=1

set PYTHONIOENCODING="UTF-8"
set PYTHONUTF8=1

rustc --version

"%PYTHON%" -m pip install . --no-deps --no-build-isolation --disable-pip-version-check ^
    || exit 2

:: dump licenses
cargo-bundle-licenses ^
    --format yaml ^
    --output "%SRC_DIR%\THIRDPARTY.yml" ^
    || exit 3
