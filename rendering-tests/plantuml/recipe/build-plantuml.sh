#!/usr/bin/env bash
set -eux -o pipefail

export MAVEN_OPTS="-Xmx1G"

gradle clean build pdfJar -x test

mkdir -p "${PREFIX}/lib" "${PREFIX}/bin"

cp build/libs/plantuml-pdf-*.jar "${PREFIX}/lib/plantuml.jar"

cat << 'EOF' | sed 's#__PREFIX__#'"${PREFIX}"'#' > "${PREFIX}/bin/plantuml"
#!/usr/bin/env bash
java -Xmx500M -jar "__PREFIX__/lib/plantuml.jar" "$@"
EOF

chmod +x "${PREFIX}/bin/plantuml"

echo "----------------------- generated wrapper script ------------------------"
cat "${PREFIX}/bin/plantuml"
echo "-------------------------------------------------------------------------"
