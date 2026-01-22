@echo on
@setlocal EnableDelayeExpansion

go build -o=%LIBRARY_PREFIX%\bin\%PKG_NAME%.exe -ldflags="-s" .\cmd\yamlfmt || goto :error
go-licenses save .\cmd\yamlfmt  --save_path=license-files || goto :error

goto :eof

:error
echo Failed with error #%errorlevel%.
exit 1
