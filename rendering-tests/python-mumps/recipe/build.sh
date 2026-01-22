set -ex

mkdir builddir

if [[ "${CONDA_BUILD_CROSS_COMPILATION:-}" == "1" && "${mpi:-}" == "openmpi" ]]; then
  export OPAL_PREFIX="${PREFIX}"
fi

if [ -n "${SP_DIR:-}" ]; then
  if [ -n "${PKG_CONFIG_PATH:-}" ]; then
    export PKG_CONFIG_PATH="${SP_DIR}/numpy/_core/lib/pkgconfig:${PKG_CONFIG_PATH}"
  else
    export PKG_CONFIG_PATH="${SP_DIR}/numpy/_core/lib/pkgconfig"
  fi
fi

meson setup ${MESON_ARGS} builddir/

${PYTHON} -m pip install --no-deps -vv --no-build-isolation --config-settings=builddir="builddir" .
