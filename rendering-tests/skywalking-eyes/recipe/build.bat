@echo on
@setlocal EnableDelayedExpansion

go build -o=%LIBRARY_PREFIX%\bin\%PKG_NAME%.exe -ldflags="-s -X github.com/apache/skywalking-eyes/commands.version=%PKG_VERSION%" .\cmd\license-eye || goto :error
go-licenses save .\cmd\license-eye --save_path=license-files || goto :error

goto :eof

:error
echo Failed with error #%errorlevel%.
exit 1
