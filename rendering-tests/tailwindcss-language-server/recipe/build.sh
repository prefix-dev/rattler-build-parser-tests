#!/usr/bin/env bash

set -o xtrace -o nounset -o pipefail -o errexit

# Create package archive and install globally
npm pack --ignore-scripts
npm install -ddd \
    --no-bin-links \
    --global \
    --build-from-source \
    ${SRC_DIR}/${PKG_NAME}-${PKG_VERSION}.tgz

mkdir -p ${PREFIX}/bin
tee ${PREFIX}/bin/tailwindcss-language-server << EOF
#!/bin/sh
\${CONDA_PREFIX}/lib/node_modules/@tailwindcss/language-server/bin/css-language-server "\$@"
EOF
chmod +x ${PREFIX}/bin/tailwindcss-language-server

tee ${PREFIX}/bin/tailwindcss-language-server.cmd << EOF
call %CONDA_PREFIX%\bin\node %CONDA_PREFIX%\lib\node_modules\@tailwindcss\language-server\bin\css-language-server %*
EOF
