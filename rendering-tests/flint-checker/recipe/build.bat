@echo on
@setlocal EnabledDelayedExpansion

set GOPROXY=https://proxy.golang.org
go mod init flint
go mod edit -replace github.com/codegangsta/cli=github.com/urfave/cli@v1
go mod tidy -e
go mod vendor -e

go build -o=%LIBRARY_PREFIX%\bin\flint.exe -ldflags="-s" || goto :error
go-licenses save . --save_path=license-files || goto :error

goto :eof

:error
echo Failed with error #%errorlevel%.
exit 1
