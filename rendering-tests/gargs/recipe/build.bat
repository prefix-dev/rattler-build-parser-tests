@echo on
@setlocal EnableDelayedExpansion

go mod init gargs || goto :error
go mod tidy -e || goto :error
go build -o=%LIBRARY_PREFIX%\bin\%PKG_NAME%.exe -ldflags="-s -w" || goto :error
go-licenses save . --save_path=license-files || goto :error

goto :eof

:error
echo Failed with #%errorlevel%.
exit 1
