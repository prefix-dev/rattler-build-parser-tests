#!/usr/bin/env bash

set -o xtrace -o nounset -o pipefail -o errexit

meson ${MESON_ARGS} \
    --wrap-mode=nofallback \
    build \
    -Dgdk-pixbuf2=enabled \
    -Dlibcurl=enabled \
    -Dtests=enabled
meson compile -C build -v -j ${CPU_COUNT}
if [[ ${CONDA_BUILD_CROSS_COMPILATION:-0} == 0 ]]; then
    if [[ ${target_platform} != "linux-ppc64le" ]] && [[ ${target_platform} != "linux-aarch64" ]]; then
        meson test -C build -j ${CPU_COUNT}
    fi
fi
meson install -C build
