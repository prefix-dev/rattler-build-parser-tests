@echo on
@setlocal EnableDelayedExpansion

go build -ldflags "-w -X main.revision=conda-forge" -v -o %LIBRARY_PREFIX%\bin\jd.exe || goto :error
go-licenses save . --save_path .\library_licenses --ignore github.com/josephburnett/jd || goto :error

goto :eof

:error
echo Failed with error #%errorlevel%.
exit 1
