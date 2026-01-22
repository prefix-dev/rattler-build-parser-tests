#!/usr/bin/env bash
set -eux
mkdir -p "${PREFIX}/bin"
"${CC}" -DPIKCHR_SHELL=1 -lm -o "${PREFIX}/bin/pikchr" "extsrc/pikchr.c"
