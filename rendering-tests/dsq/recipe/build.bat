@echo on
@setlocal EnableDelayedExpansion

go mod edit -replace github.com/mattn/go-ieproxy@v0.0.9=github.com/mattn/go-ieproxy@v0.0.11 || goto :error
go mod tidy -e || goto :error
go mod vendor -e || goto :error
go build -o="%LIBRARY_BIN%\%PKG_NAME%.exe" -ldflags="LDFLAGS=-s -X main.Version=%PKG_VERSION%" || goto :error
go-licenses save . --save_path=license-files --ignore github.com/multiprocessio/datastation/runner ^
    --ignore github.com/apache/arrow ^
    --ignore github.com/apache/thrift ^
    --ignore github.com/jmespath/go-jmespath ^
    --ignore github.com/multiprocessio/dsq ^
    --ignore github.com/multiprocessio/go-json ^
    --ignore github.com/multiprocessio/go-sqlite3-stdlib || goto :error

:: Manually copy licenses that go-licenses could not download
xcopy /s %RECIPE_DIR%\license-files\* %SRC_DIR%\license-files || goto :error

goto :eof

:error
echo Failed with error #%errorlevel%.
exit 1
