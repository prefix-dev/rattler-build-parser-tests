@echo on
@setlocal EnabledDelayedExpansion

go build -o=%LIBRARY_PREFIX%\bin\%PKG_NAME%.exe ^
    -ldflags="-s -X github.com/homeport/dyff/internal/cmd.version=%PKG_VERSION%" .\cmd\dyff || goto :error
go-licenses save .\cmd\dyff --save_path=license-files || goto :error

goto :eof

:error
echo Failed with error #%errorlevel%.
exit 1
