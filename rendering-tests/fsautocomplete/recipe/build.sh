#!/usr/bin/env bash

set -o xtrace -o nounset -o pipefail -o errexit

mkdir -p ${PREFIX}/bin
mkdir -p ${PREFIX}/libexec/${PKG_NAME}
ln -sf ${DOTNET_ROOT}/dotnet ${PREFIX}/bin

rm -rf global.json
framework_version="$(dotnet --version | sed -e 's/\..*//g').0"

# Build package with dotnet publish
cd git
dotnet tool restore
sed -i "s?<TargetFrameworks>.*</TargetFrameworks>?<TargetFrameworks>net${framework_version}</TargetFrameworks>?" \
    src/FsAutoComplete/FsAutoComplete.fsproj
dotnet publish --no-self-contained src/FsAutoComplete/FsAutoComplete.fsproj --output ${PREFIX}/libexec/${PKG_NAME} \
    --framework net${framework_version} -p:TreatWarningsAsErrors=false
rm -rf ${PREFIX}/libexec/${PKG_NAME}/${PKG_NAME}

# Create bash and batch wrappers
tee ${PREFIX}/bin/${PKG_NAME} << EOF
#!/bin/sh
exec \${DOTNET_ROOT}/dotnet exec \${CONDA_PREFIX}/libexec/fsautocomplete/fsautocomplete.dll "\$@"
EOF
chmod +x ${PREFIX}/bin/${PKG_NAME}

tee ${PREFIX}/bin/${PKG_NAME}.cmd << EOF
call %DOTNET_ROOT%\dotnet exec %CONDA_PREFIX%\libexec\fsautocomplete\fsautocomplete.dll %*
EOF

# Download dependency licenses with dotnet-project-licenses
tee ignored_packages.json << EOF
["FSharp.Control.Reactive", "FSharp.UMX", "FsToolkit.*", "IcedTasks", "Ionide.KeepAChangelog.Tasks", "LinkDotNet.StringBuilder", "Microsoft.DotNet.PlatformAbstractions", "NETStandard.Library"]
EOF
dotnet-project-licenses --input src/FsAutoComplete/FsAutoComplete.fsproj -t -d license-files -ignore ignored_packages.json

rm ${PREFIX}/bin/dotnet
