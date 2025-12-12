#!/usr/bin/env bash

set -o xtrace -o nounset -o pipefail -o errexit

mkdir -p "${PREFIX}/bin"
mkdir -p "${PREFIX}/libexec/${PKG_NAME}"
ln -sf ${DOTNET_ROOT}/dotnet ${PREFIX}/bin

export OPENSSL_ENABLE_SHA1_SIGNATURES=1

rm -rf global.json
framework_version="$(dotnet --version | sed -e 's/\..*//g').0"

# Override hardcoded .NET framework version
sed -i "s?<TargetFrameworks>.*</TargetFrameworks>?<TargetFrameworks>net${framework_version}</TargetFrameworks>?" \
    src/OmniSharp.Stdio.Driver/OmniSharp.Stdio.Driver.csproj
sed -i '/RuntimeFrameworkVersion/d;' src/OmniSharp.Stdio.Driver/OmniSharp.Stdio.Driver.csproj
sed -i '/RuntimeIdentifier/d;' src/OmniSharp.Stdio.Driver/OmniSharp.Stdio.Driver.csproj

# Build package with dotnet publish
dotnet publish --no-self-contained "src/OmniSharp.Stdio.Driver/OmniSharp.Stdio.Driver.csproj" \
    -maxcpucount:1 --output ${PREFIX}/libexec/${PKG_NAME} --framework net${framework_version} -p:TreatWarningsAsErrors=false
rm ${PREFIX}/libexec/${PKG_NAME}/OmniSharp

# Create bash and batch wrappers
tee ${PREFIX}/bin/OmniSharp << EOF
#!/bin/sh
exec \${DOTNET_ROOT}/dotnet exec \${CONDA_PREFIX}/libexec/omnisharp-roslyn/OmniSharp.dll "\$@"
EOF
chmod +x ${PREFIX}/bin/OmniSharp

tee ${PREFIX}/bin/OmniSharp.cmd << EOF
call %DOTNET_ROOT%\dotnet exec %CONDA_PREFIX%\libexec\omnisharp-roslyn\OmniSharp.dll %*
EOF

# Delete hidden file
rm test-assets/test-projects/ProjectWithWildcardPackageReference/._ProjectWithWildcardPackageReference.csproj

# Download dependency licenses with dotnet-project-licenses
tee ignored_packages.json << EOF
["NETStandard.Library", "OmniSharp.Extensions.*", "Microsoft.DotNet.PlatformAbstractions", "Microsoft.TestPlatform.*"]
EOF
dotnet-project-licenses --input src/OmniSharp.Stdio.Driver/OmniSharp.Stdio.Driver.csproj -t -d license-files -ignore ignored_packages.json

rm ${PREFIX}/bin/dotnet
