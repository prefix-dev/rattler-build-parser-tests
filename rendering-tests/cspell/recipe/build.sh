#!/usr/bin/env bash

set -o xtrace -o nounset -o pipefail -o errexit

npm pack --ignore-scripts
npm install -ddd \
    --no-bin-links \
    --global \
    --build-from-source \
    ${PKG_NAME}-${PKG_VERSION}.tgz

# Create license report for dependencies
pnpm install
pnpm-licenses generate-disclaimer --prod --output-file=third-party-licenses.txt

mkdir -p ${PREFIX}/bin
tee ${PREFIX}/bin/cspell << EOF
#!/bin/sh
exec \${CONDA_PREFIX}/lib/node_modules/cspell/bin.mjs "\$@"
EOF
chmod +x ${PREFIX}/bin/cspell

tee ${PREFIX}/bin/cspell-esm << EOF
#!/bin/sh
exec \${CONDA_PREFIX}/lib/node_modules/cspell/bin.mjs "\$@"
EOF
chmod +x ${PREFIX}/bin/cspell-esm

# Create batch wrapper
tee ${PREFIX}/bin/cspell.cmd << EOF
call %CONDA_PREFIX%\bin\node %CONDA_PREFIX%\lib\node_modules\cspell\bin.mjs %*
EOF

tee ${PREFIX}/bin/cspell-esm.cmd << EOF
call %CONDA_PREFIX%\bin\node %CONDA_PREFIX%\lib\node_modules\cspell\bin.mjs %*
EOF
