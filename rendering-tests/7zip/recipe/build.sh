#!/usr/bin/env bash

set -o xtrace -o nounset -o pipefail -o errexit

make -j${CPU_COUNT} -f makefile.gcc -C CPP/7zip/Bundles/Alone7z/
make -j${CPU_COUNT} -f makefile.gcc -C CPP/7zip/Bundles/Alone2/
make -j${CPU_COUNT} -f makefile.gcc -C CPP/7zip/Bundles/Alone/
make -j${CPU_COUNT} -f makefile.gcc -C CPP/7zip/UI/Console/

install -D -m0755 -t "${PREFIX}/bin" CPP/7zip/Bundles/Alone7z/_o/7zr
install -D -m0755 -t "${PREFIX}/bin" CPP/7zip/Bundles/Alone2/_o/7zz
install -D -m0755 -t "${PREFIX}/bin" CPP/7zip/Bundles/Alone/_o/7za
install -D -m0755 -t "${PREFIX}/bin" CPP/7zip/UI/Console/_o/7z
