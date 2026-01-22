#!/usr/bin/env bash

set -o xtrace -o nounset -o pipefail -o errexit

# Create package archive and install globally
npm pack --ignore-scripts
npm install -ddd \
    --no-bin-links \
    --global \
    --build-from-source \
    ${SRC_DIR}/cucumber-cucumber-${PKG_VERSION}.tgz

# Create license report for dependencies
pnpm install
pnpm-licenses generate-disclaimer --prod --output-file=third-party-licenses.txt

mkdir -p ${PREFIX}/bin
tee ${PREFIX}/bin/cucumber-js << EOF
#!/bin/sh
exec \${CONDA_PREFIX}/lib/node_modules/@cucumber/cucumber/bin/cucumber.js "\$@"
EOF
chmod +x ${PREFIX}/bin/cucumber-js

tee ${PREFIX}/bin/cucumber-js.cmd << EOF
call %CONDA_PREFIX%\bin\node %CONDA_PREFIX%\lib\node_modules\@cucumber\cucumber\bin\cucumber.js %*
EOF
