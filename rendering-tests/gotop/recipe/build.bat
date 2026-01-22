@echo on
@setlocal EnableDelayedExpansion

set CGO_CFLAGS="-Wno-undef-prefix" || goto :error
go build -o=%LIBRARY_PREFIX%\bin\%PKG_NAME%.exe -ldflags="-s" .\cmd\gotop || goto :error
go-licenses save .\cmd\gotop --save_path=license-files --ignore github.com/xxxserxxx/gotop || goto :error

goto :eof

:error
echo Failed with error #%errorlevel%.
exit 1
