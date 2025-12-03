#!/bin/bash

owd=${PWD}

if [[ "$PY_VER" == "3.14" ]]; then
  export PYO3_USE_ABI3_FORWARD_COMPATIBILITY=1
fi

# install the CAPI
curl --proto '=https' --tlsv1.2 -sSf https://nnpdf.github.io/pineappl/install-capi.sh | sh -s -- --prefix ${PREFIX} --version ${PKG_VERSION}

# install the python bindings
cd pineappl_py
maturin build --release --interpreter $PYTHON
cd ../target/wheels/
PYTHONDONTWRITEBYTECODE=1 PIP_CONFIG_FILE=/dev/null $PYTHON -m pip install --isolated --ignore-installed --no-deps *.whl


# install the CLI
if [[ $HOST == *arm64-apple* ]]; then
    export PKG_CONFIG_SYSROOT_DIR=${CONDA_BUILD_SYSROOT}/
    export RUSTFLAGS="$(lhapdf-config --libs)"
    export CARGO_BUILD_TARGET="aarch64-apple-darwin"
fi

cd ${owd}
$BUILD_PREFIX/bin/cargo install --features=evolve,fktable --path pineappl_cli --root ${PREFIX}
