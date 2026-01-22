#!/bin/sh

set -exuo pipefail

if [[ "${target_platform}" == "osx-arm64" ]]; then
    export npm_config_arch="arm64"
fi
# Don't use pre-built gyp packages
export npm_config_build_from_source=true
export NPM_CONFIG_USERCONFIG=/tmp/nonexistentrc

rm $PREFIX/bin/node
ln -s $BUILD_PREFIX/bin/node $PREFIX/bin/node

pnpm install --prod
pnpm licenses list --json | pnpm-licenses generate-disclaimer --json-input --output-file=ThirdPartyLicenses.txt
pnpm pack

npm install -g ${PKG_NAME}-${PKG_VERSION}.tgz

#yarn pack
#yarn licenses generate-disclaimer --production > ThirdPartyLicenses.txt
#NPM_CONFIG_USERCONFIG=/tmp/nonexistentrc
#npm install --build-from-source -g ${PKG_NAME}-v${PKG_VERSION}.tgz
