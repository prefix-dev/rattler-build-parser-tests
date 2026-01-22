#!/usr/bin/env bash
set -exuo pipefail

# Ensure deterministic, ASCII-compatible locale for Meson
export LC_ALL=C

# Make sure ninja is used and discoverable
export NINJA="$(command -v ninja)"

# Prefer pkg-config files from the target prefix
export PKG_CONFIG_PATH="${PREFIX}/lib/pkgconfig:${PKG_CONFIG_PATH:-}"

# Use the build-prefix pkg-config by default for Meson configuration
export PKG_CONFIG="${BUILD_PREFIX}/bin/pkg-config"

# Meson arguments are provided by the meson package (e.g. --prefix, --buildtype)
# We additionally disable the OpenGL backend here and rely on Vulkan + shaderc.
# Dovi awaiting feedstock for it.
meson setup build \
    -Dopengl=disabled \
    -Ddemos=false \
    -Dbench=false \
    -Dtests=false \
    -Dvulkan=enabled \
    -Dshaderc=enabled \
    -Dlcms=enabled \
    -Ddovi=disabled \
    -Dxxhash=enabled \
    -Dvk-proc-addr=enabled \
    ${MESON_ARGS}

meson compile -C build --verbose
meson install -C build

