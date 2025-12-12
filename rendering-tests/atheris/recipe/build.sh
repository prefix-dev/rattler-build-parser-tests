#!/usr/bin/env bash
set -eux

export "CLANG_BIN=${BUILD_PREFIX}/bin/clang"

"${CLANG_BIN}" --version

# build and install the wheel to avoid issues on MacOS
"${PYTHON}" setup.py bdist_wheel --dist-dir=dist

python -m pip install \
    -vvv \
    atheris \
    --find-links=dist \
    --no-deps \
    --no-cache-dir \
