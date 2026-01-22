@echo on
@setlocal EnableDelayedExpansion

go build -o=%LIBRARY_PREFIX%\bin\%PKG_NAME%.exe -ldflags="-s" -tags fts5,icu || goto :error
go-licenses save . --save_path=license-files --ignore github.com/zk-org/zk || goto :error

goto :eof

:error
echo Failed with error #%errorlevel%.
exit 1
