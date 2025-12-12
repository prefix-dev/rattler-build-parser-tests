#!/usr/bin/env bash

set -o xtrace -o nounset -o pipefail -o errexit

mkdir -p ${PREFIX}/bin
mkdir -p ${PREFIX}/libexec/${PKG_NAME}
ln -sf ${DOTNET_ROOT}/dotnet ${PREFIX}/bin

# Build package with dotnet publish
rm -rf global.json
rm -rf .config/dotnet-tools.json
framework_version="$(dotnet --version | sed -e 's/\..*//g').0"
dotnet publish --no-self-contained Src/CSharpier.Cli/CSharpier.Cli.csproj --output ${PREFIX}/libexec/${PKG_NAME} \
    --framework net${framework_version} -p:TreatWarningAsErrors=false
rm ${PREFIX}/libexec/${PKG_NAME}/CSharpier

# Create bash and batch wrappers
tee ${PREFIX}/bin/dotnet-csharpier << EOF
#!/bin/sh
exec \${DOTNET_ROOT}/dotnet exec \${CONDA_PREFIX}/libexec/csharpier/CSharpier.dll "\$@"
EOF
chmod +x ${PREFIX}/bin/dotnet-csharpier

tee ${PREFIX}/bin/dotnet-csharpier.cmd << EOF
call %DOTNET_ROOT%\dotnet exec %CONDA_PREFIX\libexec\csharpier\CSharpier.dll %*
EOF

# Download dependency licenses with dotnet-project-licenses
tee ignored_packages.json << EOF
["Ignore", "YamlDotNet", "StrongNamer"]
EOF

dotnet-project-licenses --input Src/CSharpier.Cli/CSharpier.Cli.csproj -t -d license-files -ignore ignored_packages.json

rm ${PREFIX}/bin/dotnet
