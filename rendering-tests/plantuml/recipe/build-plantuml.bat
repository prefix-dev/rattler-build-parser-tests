@ECHO ON

CALL gradlew.bat
CALL gradlew clean build pdfJar -x test
CALL gradlew --stop

IF NOT EXIST "%LIBRARY_LIB%" mkdir "%LIBRARY_LIB%"
IF NOT EXIST "%LIBRARY_BIN%" mkdir "%LIBRARY_BIN%"

CALL echo F | xcopy .\build\libs\plantuml-pdf-*.jar "%LIBRARY_LIB%\plantuml.jar"

ECHO java -Xmx500M -jar %LIBRARY_LIB%\plantuml.jar "$@"     %%*> %LIBRARY_BIN%\plantuml.bat
ECHO IF %%ERRORLEVEL%% NEQ 0 EXIT /B %%ERRORLEVEL%%         >> %LIBRARY_BIN%\plantuml.bat

ECHO "----------------------- generated wrapper script ------------------------"
TYPE "%LIBRARY_BIN%\plantuml.bat"
ECHO "-------------------------------------------------------------------------"
