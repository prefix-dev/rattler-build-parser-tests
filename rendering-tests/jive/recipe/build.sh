# Update the version in pom files (remove SNAPSHOT)
mvn versions:set versions:update-child-modules -DnewVersion="${PKG_VERSION}" -DprocessAllModule -DgenerateBackupPoms=false -Prelease
# Skip the tests because they require to have a tango database running
mvn install -DskipTests

# Generate third party license report
mvn license:aggregate-third-party-report
cp target/reports/aggregate-third-party-report.html .

mkdir -p ${PREFIX}/share/java ${PREFIX}/bin

install -m 0644 target/Jive-${PKG_VERSION}-jar-with-dependencies.jar ${PREFIX}/share/java
ln -s Jive-${PKG_VERSION}-jar-with-dependencies.jar ${PREFIX}/share/java/Jive.jar

# Create jive script
cat << EOF > $PREFIX/bin/jive
#!/bin/sh

if [ ! \$TANGO_HOST ] && [ -f /etc/tangorc ]; then
   . /etc/tangorc
fi

export CLASSPATH=${PREFIX}/share/java/Jive.jar
LOGBACK=\${TANGO_LOGBACK:-${PREFIX}/share/tango/logback.xml}

java \
    -DTANGO_HOST=\$TANGO_HOST \
    -Dlogback.configurationFile="\$LOGBACK" \
    jive3.MainPanel \$@
EOF
chmod a+x $PREFIX/bin/jive
