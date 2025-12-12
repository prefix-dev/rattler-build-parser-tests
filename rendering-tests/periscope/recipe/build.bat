@echo on
@setlocal EnableDelayedExpansion

go build -o=%LIBRARY_PREFIX%\bin\psc.exe -ldflags="-s -X main.version=%PKG_VERSION%" .\cmd\psc || goto :error
go-licenses save .\cmd\psc --save_path=license-files --ignore github.com/anishathalye/periscope || goto :error

goto :eof

:error
echo Failed with error #%errorlevel%.
exit 1
