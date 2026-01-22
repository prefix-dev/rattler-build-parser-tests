@echo on

go build -o=%LIBRARY_PREFIX%\bin\%PKG_NAME%.exe -ldflags="-s -w" || goto :error
go-licenses save . --save_path=license-files || goto :error

goto :eof

:error
echo Failed with #%errorlevel%.
exit 1
