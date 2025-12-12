#!/bin/sh

if [[ "${target_platform}" == "osx-arm64" ]]; then
  export npm_config_arch="arm64"
fi
# Don't use pre-built gyp packages
export npm_config_build_from_source=true

if [[ "${target_platform}" == linux-* ]]; then
  # We need to be more permissive to get the code compiling
  export CFLAGS="${CFLAGS} -fpermissive"
  export CXXFLAGS="${CXXFLAGS} -fpermissive"
fi

rm $PREFIX/bin/node
ln -s $BUILD_PREFIX/bin/node $PREFIX/bin/node

mkdir -p $PREFIX/share/vega-lite-cli
pushd $PREFIX/share/vega-lite-cli
yarn global add install-peerdeps
yarn add vega-lite@$PKG_VERSION
yarn add vega@^5.22.0


pushd $PREFIX/bin
for cmd in vl2pdf vl2png vl2svg vl2vg
do
    ln -s ../share/vega-lite-cli/node_modules/vega-lite/bin/$cmd .
done

cp $PREFIX/share/vega-lite-cli/node_modules/vega-lite/LICENSE $SRC_DIR
