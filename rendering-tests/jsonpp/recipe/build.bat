@echo on
@setlocal EnableDelayedExpansion

set GOPROXY=https://proxy.golang.org || goto :error
go mod init jsonpp || goto :error
go mod tidy || goto :error
go build -o=%LIBRARY_PREFIX%\bin\%PKG_NAME%.exe -ldflags="-s" || goto :error
go-licenses save . --save_path=license-files || goto :error

goto :eof

:error
echo Failed with error #%errorlevel%.
exit 1
