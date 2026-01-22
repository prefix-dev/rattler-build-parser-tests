#!/usr/bin/env bash

set -o xtrace -o nounset -o pipefail -o errexit

mkdir -p ${PREFIX}/libexec/${PKG_NAME}
mkdir -p ${PREFIX}/bin

# Add dependency-license-report as a plugin to build.gradle
sed -i 's/alias(libs.plugins.jreleaser)/alias(libs.plugins.jreleaser)\nid("com.github.jk1.dependency-license-report") version "latest.release"/' build.gradle.kts

# Build with gradle and copy outputs
./gradlew clean build -x :smithy-cli:test
./gradlew generateLicenseReport --no-parallel
find . -name '*.jar' | grep "build/libs" | xargs -I % cp % ${PREFIX}/libexec/${PKG_NAME}

# Create bash and batch files
tee ${PREFIX}/bin/smithy << EOF
#!/bin/sh
exec \${JAVA_HOME}/bin/java -jar \${CONDA_PREFIX}/libexec/smithy/smithy-cli-${PKG_VERSION}.jar "\$@"
EOF
chmod +x ${PREFIX}/bin/smithy

tee ${PREFIX}/bin/smithy.cmd << EOF
call %JAVA_HOME%\bin\java -jar %CONDA_PREFIX%\libexec\smithy\smithy-cli-${PKG_VERSION}.jar %*
EOF
