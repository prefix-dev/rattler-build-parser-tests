#!/usr/bin/env bash

set -o xtrace -o nounset -o pipefail -o errexit

mkdir -p ${PREFIX}/bin
mkdir -p ${PREFIX}/libexec/${PKG_NAME}
ln -sf ${DOTNET_ROOT}/dotnet ${PREFIX}/bin

# Build package with dotnet publish
rm -rf global.json
framework_version="$(dotnet --version | sed -e 's/\..*//g').0"
dotnet publish --no-self-contained src/MiniCover/MiniCover.csproj --output ${PREFIX}/libexec/${PKG_NAME} --framework "net${framework_version}"
rm ${PREFIX}/libexec/${PKG_NAME}/MiniCover

# Create bash and batch wrappers
tee ${PREFIX}/bin/minicover << EOF
#!/bin/sh
exec \${DOTNET_ROOT}/dotnet exec \${CONDA_PREFIX}/libexec/minicover/MiniCover.dll "\$@"
EOF
chmod +x ${PREFIX}/bin/minicover

tee ${PREFIX}/bin/minicover.cmd << EOF
call %DOTNET_ROOT%\dotnet exec %CONDA_PREFIX%\libexec\minicover\MiniCover.dll %*
EOF

# Download dependency licenses wtih dotnet-project-licenses
dotnet-project-licenses --input src/MiniCover/MiniCover.csproj -t -d license-files

rm ${PREFIX}/bin/dotnet
