set "PYCURL_CURL_DIR=%LIBRARY_PREFIX%"
set "PYCURL_USE_LIBCURL_DLL=1"
set "PYCURL_SSL_LIBRARY=schannel"

%PYTHON% -m pip install . --no-deps -vv
if errorlevel 1 exit 1

rd /s /q %PREFIX%\Doc
