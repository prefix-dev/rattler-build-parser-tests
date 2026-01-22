#!/usr/bin/env bash

set -o xtrace -o nounset -o pipefail -o errexit

# Build JAR files with sbt
# Create pom.xml files so maven can be used to download licenses
sbt 'set baseVersionSuffix := ""' dist/mkPack makePom

mkdir -p ${SRC_DIR}/target/generated-resources/licenses

midver=$(echo $PKG_VERSION | sed 's/[[:digit:]]\+\.\([[:digit:]]\+\)\.[[:digit:]]\+/\1/')
filename=scala-dist-${PKG_VERSION}.pom
if [ ${midver+x} == "12" ]; then
    distDir="scala-dist"
else
    distDir="scalaDist"
fi
pom_file="${SRC_DIR}/target/${distDir}/${filename}"

pushd $(dirname ${pom_file})
mv ${filename} pom.xml
if [ ${midver+x} == "12" ]; then
    sed -i 's/scala-library-all/scala-library/' pom.xml
fi
mvn license:download-licenses -Dgoal=download-licenses
cp ./target/generated-resources/licenses/* ${SRC_DIR}/target/generated-resources/licenses
popd

# Install JAR files
mkdir -p ${PREFIX}/bin
mkdir -p ${PREFIX}/libexec/scala2

cp -r ./build/pack/* ${PREFIX}/libexec/scala2/

for FILE in fsc scala scalac scaladoc scalap; do
    tee ${PREFIX}/bin/${FILE} << EOF
#!/bin/sh
exec \${CONDA_PREFIX}/libexec/scala2/bin/${FILE} "\$@"
EOF
    chmod +x ${PREFIX}/bin/${FILE}

    tee ${PREFIX}/bin/${FILE}.bat << EOF
@echo off
call "%CONDA_PREFIX%\libexec\scala2\bin\${FILE}.bat" %*
EOF
done

for CHANGE in "activate" "deactivate"
do
    mkdir -p "${PREFIX}/etc/conda/${CHANGE}.d"
    cp "${RECIPE_DIR}/scripts/${CHANGE}"* "${PREFIX}/etc/conda/${CHANGE}.d/"
done
