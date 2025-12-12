@echo on
@setlocal EnableDelayedExpansion

go build -o=%LIBRARY_PREFIX%\bin\%PKG_NAME%.exe -ldflags="-s -X github.com/pdfcpu/pdfcpu/pkg/pdfcpu.VersionStr=%PKG_VERSION%" .\cmd\pdfcpu || goto :error
go-licenses save .\cmd\pdfcpu --save_path=license-files || goto :error

goto :eof

:error
echo Failed with error #%errorlevel%.
exit 1
