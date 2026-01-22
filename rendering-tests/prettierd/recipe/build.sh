#!/usr/bin/env bash

set -o xtrace -o nounset -o pipefail -o errexit

# Patch package.json to skip unneessary prepare step
mv package.json package.json.bak
jq 'del(.scripts.prepare)' package.json.bak > package.json

# Create package archive and install globally
npm pack --ignore-scripts
npm install -ddd \
    --no-bin-links \
    --global \
    --build-from-source \
    fsouza-${PKG_NAME}-${PKG_VERSION}.tgz

# Create license report for dependencies
mv package.json package.json.bak
jq 'del(.packageManager)' package.json.bak > package.json
pnpm install
pnpm-licenses generate-disclaimer --prod --output-file=third-party-licenses.txt

mkdir -p ${PREFIX}/bin
tee ${PREFIX}/bin/prettierd << EOF
#!/bin/sh
exec \${CONDA_PREFIX}/lib/node_modules/@fsouza/prettierd/bin/prettierd "\$@"
EOF
chmod +x ${PREFIX}/bin/prettierd

# Create batch wrapper
tee ${PREFIX}/bin/prettierd.cmd << EOF
call %CONDA_PREFIX%\bin\node %CONDA_PREFIX%\lib\node_modules\@fsouza\prettierd\bin\prettierd %*
EOF
