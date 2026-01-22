#!/usr/bin/env bash

set -o xtrace -o nounset -o pipefail -o errexit

mkdir -p ${PREFIX}/libexec/ktfmt
mkdir -p ${PREFIX}/bin

# Add dependency-license-report plugin
sed -i 's/alias(libs.plugins.shadowJar) apply false/alias(libs.plugins.shadowJar) apply false\nid("com.github.jk1.dependency-license-report") version "latest.release"/' build.gradle.kts

# Build with gradle
./gradlew :ktfmt:shadowJar
./gradlew generateLicenseReport

install -m 644 core/build/libs/ktfmt-${PKG_VERSION}-with-dependencies.jar ${PREFIX}/libexec/ktfmt/ktfmt.jar

# Create bash and batch files
tee ${PREFIX}/bin/ktfmt << EOF
#!/bin/sh
exec \${JAVA_HOME}/bin/java -jar \${CONDA_PREFIX}/libexec/ktfmt/ktfmt.jar "\$@"
EOF
chmod +x ${PREFIX}/bin/ktfmt

tee ${PREFIX}/bin/ktfmt.cmd << EOF
call %JAVA_HOME%\bin\java -jar %CONDA_PREFIX%\libexec\ktfmt\ktfmt.jar %*
EOF
