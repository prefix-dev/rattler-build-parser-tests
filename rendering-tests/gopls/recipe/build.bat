@echo on
@setlocal EnableDelayedExpansion

cd gopls || goto :error
go build -o="%LIBRARY_BIN%\%PKG_NAME%.exe" -ldflags="-s" || goto :error
go-licenses save . --save_path=..\license-files --ignore golang.org/x/tools/gopls || goto :error

goto :eof

:error
echo Failed with error #%errorlevel%.
exit 1
