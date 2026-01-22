#!/usr/bin/env bash

set -o xtrace -o nounset -o pipefail -o errexit

mkdir -p ${PREFIX}/bin
mkdir -p ${PREFIX}/libexec/fsharplint
ln -sf ${DOTNET_ROOT}/dotnet ${PREFIX}/bin

rm -rf global.json
rm -rf .config/dotnet-tools.json
framework_version="$(dotnet --version | sed -e 's/\..*//g').0"

# Use .net 8.0 instead of 6.0
sed -i "s?<TargetFrameworks>.*</TargetFrameworks>?<TargetFrameworks>net${framework_version}</TargetFrameworks>?" \
    src/FSharpLint.Console/FSharpLint.Console.fsproj
sed -i "s?<TargetFrameworks>.*</TargetFrameworks>?<TargetFrameworks>net${framework_version}</TargetFrameworks>?" \
    src/FSharpLint.Core/FSharpLint.Core.fsproj
sed -i "s?<TargetFrameworks>.*</TargetFrameworks>?<TargetFrameworks>net${framework_version}</TargetFrameworks>?" \
    tests/FSharpLint.Benchmarks/FSharpLint.Benchmarks.fsproj
sed -i "s?<TargetFrameworks>.*</TargetFrameworks>?<TargetFrameworks>net${framework_version}</TargetFrameworks>?" \
    tests/FSharpLint.Console.Tests/FSharpLint.Console.Tests.fsproj
sed -i "s?<TargetFrameworks>.*</TargetFrameworks>?<TargetFrameworks>net${framework_version}</TargetFrameworks>?" \
    tests/FSharpLint.Core.Tests/FSharpLint.Core.Tests.fsproj
sed -i "s?<TargetFrameworks>.*</TargetFrameworks>?<TargetFrameworks>net${framework_version}</TargetFrameworks>?" \
    tests/FSharpLint.FunctionalTest/FSharpLint.FunctionalTest.fsproj

# paket install
dotnet publish --no-self-contained src/FSharpLint.Console/FSharpLint.Console.fsproj --output ${PREFIX}/libexec/fsharplint --framework net${framework_version}
rm -rf ${PREFIX}/libexec/fsharplint/dotnet-fsharplint

tee ${PREFIX}/bin/dotnet-fsharplint << EOF
#!/bin/sh
exec \${DOTNET_ROOT}/dotnet exec \${CONDA_PREFIX}/libexec/fsharplint/dotnet-fsharplint.dll "\$@"
EOF
chmod +x ${PREFIX}/bin/dotnet-fsharplint

# Download dependency licenses with dotnet-project-licenses
tee ignored_packages.json << EOF
["SemanticVersioning", "FSharp.Control.Reactive"]
EOF
dotnet-project-licenses --input src/FSharpLint.Console/FSharpLint.Console.fsproj -t -d license-files -ignore ignored_packages.json

rm ${PREFIX}/bin/dotnet
