@ECHO OFF

set CLASSPATH=%CONDA_PREFIX%\share\java\Jive.jar

start javaw -DTANGO_HOST=%TANGO_HOST% -Dlogback.configurationFile="%CONDA_PREFIX%\share\tango\logback.xml" jive3.MainPanel %*
