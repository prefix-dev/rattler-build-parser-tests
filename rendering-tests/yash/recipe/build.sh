#!/bin/bash

set -exo pipefail

if [[ "${target_platform}" == "osx-"* ]]; then
    export CC=$(command -v clang)
fi

export A2XFLAGS="--no-xmllint -v --xsltproc-opts=\"--maxdepth 1000000\" \
    --xsl-file=${BUILD_PREFIX}/share/docbook-xsl/manpages/docbook.xsl"

if [[ "${target_platform}" == "osx-arm64" ]]; then
    ./configure --prefix=${PREFIX} --disable-nls
else
    ./configure --prefix=${PREFIX}
fi

pushd po
make yash.pot
msginit --no-translator -l en@boldquot -i yash.pot -o en@boldquot.po
sed -i.bak 's/charset=ASCII/charset=UTF-8/' en@boldquot.po
rm en@boldquot.po.bak
popd

make -j${CPU_COUNT}
make install
