set -ex

mkdir builddir

export PKG_CONFIG_PATH=$(numpy-config --pkgconfigdir):${PKG_CONFIG_PATH}

meson setup ${MESON_ARGS} -Dwith_extensions=true builddir/

${PYTHON} -m pip install --no-deps -vv --no-build-isolation --config-settings=builddir="builddir" .
