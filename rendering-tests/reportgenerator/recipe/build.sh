#!/usr/bin/env bash

set -o xtrace -o nounset -o pipefail -o errexit

mkdir -p ${PREFIX}/bin
mkdir -p ${PREFIX}/libexec/${PKG_NAME}
ln -sf ${DOTNET_ROOT}/dotnet ${PREFIX}/bin

export OPENSSL_ENABLE_SHA1_SIGNATURES=1

# Build package with dotnet publish
rm -rf global.json
framework_version="$(dotnet --version | sed -e 's/\..*//g').0"
dotnet publish --no-self-contained src/ReportGenerator.DotnetGlobalTool/ReportGenerator.DotnetGlobalTool.csproj --output ${PREFIX}/libexec/${PKG_NAME} --framework "net${framework_version}"
rm ${PREFIX}/libexec/${PKG_NAME}/ReportGenerator

# Create bash and batch wrappers
tee ${PREFIX}/bin/reportgenerator << EOF
#!/bin/sh
exec \${DOTNET_ROOT}/dotnet exec \${CONDA_PREFIX}/libexec/reportgenerator/ReportGenerator.dll "\$@"
EOF
chmod +x ${PREFIX}/bin/reportgenerator

tee ${PREFIX}/bin/reportgenerator.cmd << EOF
call %DOTNET_ROOT%\dotnet exec %CONDA_PREFIX%\libexec\reportgenerator\ReportGenerator.dll %*
EOF

# Download dependency licenses wtih dotnet-project-licenses
tee ignored_packages.json << EOF
["Microsoft.DotNet.PlatformAbstractions"]
EOF
dotnet-project-licenses --input src/ReportGenerator.DotnetGlobalTool/ReportGenerator.DotnetGlobalTool.csproj -t -d license-files -ignore ignored_packages.json

rm ${PREFIX}/bin/dotnet
