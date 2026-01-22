#!/usr/bin/env bash

set -o xtrace -o nounset -o pipefail -o errexit

mkdir -p ${PREFIX}/bin
mkdir -p ${PREFIX}/libexec/${PKG_NAME}
ln -sf ${DOTNET_ROOT}/dotnet ${PREFIX}/bin

# Build package with dotnet publish
rm -rf global.json
framework_version="$(dotnet --version | sed -e 's/\..*//g').0"
# sed -i "s?<TargetFramework>.*</TargetFramework>?<TargetFramework>net${framework_version}</TargetFramework>?" \
#     source/Nuke.ProjectModel/Nuke.ProjectModel.csproj

dotnet publish --no-self-contained "source/Nuke.GlobalTool/Nuke.GlobalTool.csproj" --output ${PREFIX}/libexec/${PKG_NAME}
rm -rf ${PREFIX}/libexec/${PKG_NAME}/Nuke.GlobalTool

# Create bash and batch wrappers
tee ${PREFIX}/bin/nuke << EOF
#!/bin/sh
exec \${DOTNET_ROOT}/dotnet exec \${CONDA_PREFIX}/libexec/nuke/Nuke.GlobalTool.dll "\$@"
EOF
chmod +x ${PREFIX}/bin/nuke

tee ${PREFIX}/bin/nuke.cmd << EOF
call %DOTNET_ROOT%\dotnet exec %CONDA_PREFIX%\libexec\nuke\Nuke.GlobalTool.dll %*
EOF

# Download dependency licenses with dotnet-project-licenses
tee ignored_packages.json << EOF
["Humanizer.Core", "YamlDotNet"]
EOF
dotnet-project-licenses --input source/Nuke.GlobalTool/Nuke.GlobalTool.csproj -t -d license-files -ignore ignored_packages.json

rm ${PREFIX}/bin/dotnet
