#!/usr/bin/env bash

set -o xtrace -o nounset -o pipefail -o errexit

# Package package.json to skip unnecessary prepare step
mv package.json package.json.bak
jq 'del(.scripts.prepare)' package.json.bak > package.json

# Create package archive and install globally
npm pack --ignore-scripts
npm install -ddd \
    --no-bin-links \
    --global \
    --build-from-source \
    ${SRC_DIR}/${PKG_NAME}-${PKG_VERSION}.tgz

# Create license report for dependencies
pnpm install
pnpm-licenses generate-disclaimer --prod --output-file=third-party-licenses.txt

mkdir -p ${PREFIX}/bin
tee ${PREFIX}/bin/sql-formatter << EOF
#!/bin/sh
exec \${CONDA_PREFIX}/lib/node_modules/sql-formatter/bin/sql-formatter-cli.cjs "\$@"
EOF
chmod +x ${PREFIX}/bin/sql-formatter

# Create batch wrapper
tee ${PREFIX}/bin/sql-formatter.cmd << EOF
call %CONDA_PREFIX%\bin\node %CONDA_PREFIX%\lib\node_modules\sql-formatter\bin\sql-formatter-cli.cjs %*
EOF
