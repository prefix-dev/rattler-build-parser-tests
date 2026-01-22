#!/usr/bin/env bash
set -eux

# shellcheck disable=SC2155
export CC="$(basename "${CC}")"

ln -s "${BUILD_PREFIX}/bin/${CC}" "${BUILD_PREFIX}/bin/cc"
ln -s "${BUILD_PREFIX}/bin/python" "${PREFIX}/bin/python"

emsdk install latest
emsdk activate latest

# shellcheck disable=SC1091
. "${CONDA_EMSDK_DIR}/emsdk_env.sh"

./configure \
  --prefix="${PREFIX}" \
  --build="${BUILD}" \
  --host="${HOST}" \
  --internal-sqlite=0 \
  --json=1 \
  --with-openssl="${PREFIX}" \
  --with-sqlite="${PREFIX}" \
  --with-tcl="${PREFIX}" \
  --with-zlib="${PREFIX}/include" \
  || exit 1

make wasm

make

make install --debug

rm "${PREFIX}/bin/python"
