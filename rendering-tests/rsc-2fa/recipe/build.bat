@echo on
@setlocal EnableDelayedExpansion

go mod vendor || goto :error
go build -o=%LIBRARY_PREFIX%\bin\2fa.exe -ldflags="-s" || goto :error
go-licenses save . --save_path=license-files || goto :error

goto :eof

:error
echo Failed with error #%errorlevel%.
exit 1
