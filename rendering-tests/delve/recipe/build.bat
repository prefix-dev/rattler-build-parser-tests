@echo on
@setlocal EnableDelayedExpansion

go build -o=%LIBRARY_PREFIX%\bin\dlv.exe -ldflags="-s" .\cmd\dlv || goto :error
go-licenses save .\cmd\dlv --save_path=license-files || goto :error

goto :eof

:error
echo Failed with error #%errorlevel%.
exit 1
