set MYSQLCLIENT_CONNECTOR=%LIBRARY_PREFIX%

python -m pip install . -vvv
if errorlevel 1 exit 1
