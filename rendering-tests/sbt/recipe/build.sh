#!/usr/bin/env bash

# Script inspired by the contents of the sbt debian packages.
# Debian packages: https://dl.bintray.com/sbt/debian/

mkdir -p ${PREFIX}/share/sbt/bin
mkdir -p ${PREFIX}/bin

cp ./bin/sbt ./bin/sbt-launch.jar ${PREFIX}/share/sbt/bin/
cp ${RECIPE_DIR}/sbt ${PREFIX}/bin/sbt
cp ${RECIPE_DIR}/sbt.bat ${PREFIX}/bin/sbt.bat
