@echo on
cd python

set "OPENSSL_DIR=%LIBRARY_PREFIX%"

"%PYTHON%" -m pip install . -vv --no-deps --no-build-isolation --disable-pip-version-check ^
  || exit 2

cargo-bundle-licenses ^
  --format yaml ^
  --output "%SRC_DIR%\THIRDPARTY.yml" ^
  || exit 3
