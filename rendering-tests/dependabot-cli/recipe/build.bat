@echo on
@setlocal EnableDelayedExpansion

go build -o=%LIBRARY_PREFIX%\bin\dependabot.exe -ldflags="-s" .\cmd\dependabot || goto :error
go-licenses save .\cmd\dependabot --save_path=license-files || goto :error

goto :eof

:error
echo Failed with error #%errorlevel%.
exit 1
