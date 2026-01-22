@echo on
@setlocal EnableDelayedExpansion

go build -o=%LIBRARY_PREFIX%\bin\%PKG_NAME%.exe -ldflags="-s -X src.elv.sh/pkg/buildinfo.VersionSuffix=" .\cmd\elvish || goto :error
go-licenses save .\cmd\elvish --save_path=license-files || goto :error

goto :eof

:error
echo Failed with error #%errorlevel%.
exit 1
