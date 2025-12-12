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

# Later install steps need a valid git repository
git init .
git config user.email "you@example.com"
git config user.name "Your Name"
git add .
git commit -m "Initial commit" --no-verify --no-gpg-sign

cd packages/parser
yarn install
pnpm install --prod
pnpm licenses list --json | pnpm-licenses generate-disclaimer --json-input --output-file=ThirdPartyLicenses.txt
pnpm pack

npm install -g ${PKG_NAME}-${PKG_VERSION}.tgz
